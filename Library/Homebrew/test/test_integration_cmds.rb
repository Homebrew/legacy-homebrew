require "bundler"
require "testing_env"
require "core_formula_repository"
require "fileutils"
require "pathname"

class IntegrationCommandTests < Homebrew::TestCase
  def setup
    @cmd_id_index = 0 # Assign unique IDs to invocations of `cmd_output`.
  end

  def cmd_id_from_args(args)
    args_pretty = args.join(" ").gsub(TEST_TMPDIR, "@TMPDIR@")
    test_pretty = "#{self.class.name}\##{name}.#{@cmd_id_index += 1}"
    "[#{test_pretty}] brew #{args_pretty}"
  end

  def cmd_output(*args)
    # 1.8-compatible way of writing def cmd_output(*args, **env)
    env = args.last.is_a?(Hash) ? args.pop : {}
    cmd_args = %W[
      -W0
      -I#{HOMEBREW_LIBRARY_PATH}/test/lib
      -rconfig
      -rintegration_mocks
    ]
    cmd_args << "-rsimplecov" if ENV["HOMEBREW_TESTS_COVERAGE"]
    cmd_args << (HOMEBREW_LIBRARY_PATH/"../brew.rb").resolved_path.to_s
    cmd_args += args
    Bundler.with_original_env do
      ENV["HOMEBREW_BREW_FILE"] = HOMEBREW_PREFIX/"bin/brew"
      ENV["HOMEBREW_INTEGRATION_TEST"] = cmd_id_from_args(args)
      ENV["HOMEBREW_TEST_TMPDIR"] = TEST_TMPDIR
      env.each_pair { |k,v| ENV[k] = v }

      read, write = IO.pipe
      begin
        pid = fork do
          read.close
          $stdout.reopen(write)
          $stderr.reopen(write)
          write.close
          exec RUBY_PATH, *cmd_args
        end
        write.close
        read.read.chomp
      ensure
        Process.wait(pid)
        read.close
      end
    end
  end

  def cmd(*args)
    output = cmd_output(*args)
    $stderr.write output unless $?.success?
    assert_equal 0, $?.exitstatus
    output
  end

  def cmd_fail(*args)
    output = cmd_output(*args)
    assert_equal 1, $?.exitstatus
    output
  end

  def testball
    "#{File.expand_path("..", __FILE__)}/testball.rb"
  end

  def test_prefix
    assert_equal HOMEBREW_PREFIX.to_s,
                 cmd("--prefix")
  end

  def test_version
    assert_match HOMEBREW_VERSION.to_s,
                 cmd("--version")
  end

  def test_cache
    assert_equal HOMEBREW_CACHE.to_s,
                 cmd("--cache")
  end

  def test_cache_formula
    assert_match %r{#{HOMEBREW_CACHE}/testball-},
                 cmd("--cache", testball)
  end

  def test_cellar
    assert_equal HOMEBREW_CELLAR.to_s,
                 cmd("--cellar")
  end

  def test_cellar_formula
    assert_match "#{HOMEBREW_CELLAR}/testball",
                 cmd("--cellar", testball)
  end

  def test_env
    assert_match %r{CMAKE_PREFIX_PATH="#{HOMEBREW_PREFIX}[:"]},
                 cmd("--env")
  end

  def test_prefix_formula
    assert_match "#{HOMEBREW_CELLAR}/testball",
                 cmd("--prefix", testball)
  end

  def test_repository
    assert_match HOMEBREW_REPOSITORY.to_s,
                 cmd("--repository")
  end

  def test_help
    assert_match "Example usage:",
                 cmd("help")
  end

  def test_config
    assert_match "HOMEBREW_VERSION: #{HOMEBREW_VERSION}",
                 cmd("config")
  end

  def test_install
    assert_match "#{HOMEBREW_CELLAR}/testball/0.1", cmd("install", testball)
  ensure
    cmd("uninstall", "--force", testball)
    cmd("cleanup", "--force", "--prune=all")
  end

  def test_bottle
    cmd("install", "--build-bottle", testball)
    assert_match "Formula not from core or any taps",
                 cmd_fail("bottle", "--no-revision", testball)
    formula_file = CoreFormulaRepository.new.formula_dir/"testball.rb"
    formula_file.write <<-EOS.undent
      class Testball < Formula
        url "https://example.com/testball-0.1.tar.gz"
      end
    EOS
    HOMEBREW_CACHE.cd do
      assert_match(/testball-0\.1.*\.bottle\.tar\.gz/,
                   cmd_output("bottle", "--no-revision", "testball"))
    end
  ensure
    cmd("uninstall", "--force", "testball")
    cmd("cleanup", "--force", "--prune=all")
    formula_file.unlink unless formula_file.nil?
  end

  def test_uninstall
    cmd("install", testball)
    assert_match "Uninstalling testball", cmd("uninstall", "--force", testball)
  ensure
    cmd("cleanup", "--force", "--prune=all")
  end

  def test_cleanup
    (HOMEBREW_CACHE/"test").write "test"
    assert_match "#{HOMEBREW_CACHE}/test", cmd("cleanup", "--prune=all")
  ensure
    FileUtils.rm_f HOMEBREW_CACHE/"test"
  end

  def test_readall
    repo = CoreFormulaRepository.new
    formula_file = repo.formula_dir/"foo.rb"
    formula_file.write <<-EOS.undent
      class Foo < Formula
        url "https://example.com/foo-1.0.tar.gz"
      end
    EOS
    alias_file = repo.alias_dir/"bar"
    alias_file.parent.mkpath
    FileUtils.ln_s formula_file, alias_file
    cmd("readall", "--aliases", "--syntax")
    cmd("readall", "Homebrew/homebrew")
  ensure
    formula_file.unlink unless formula_file.nil?
    repo.alias_dir.rmtree
  end

  def test_tap
    path = Tap::TAP_DIRECTORY/"homebrew/homebrew-foo"
    path.mkpath
    path.cd do
      shutup do
        system "git", "init"
        system "git", "remote", "add", "origin", "https://github.com/Homebrew/homebrew-foo"
        system "git", "add", "--all"
        system "git", "commit", "-m", "init"
      end
    end

    assert_match "homebrew/foo", cmd("tap")
    assert_match "homebrew/versions", cmd("tap", "--list-official")
    assert_match "1 tap", cmd("tap-info")
    assert_match "https://github.com/Homebrew/homebrew-foo", cmd("tap-info", "homebrew/foo")
    assert_match "https://github.com/Homebrew/homebrew-foo", cmd("tap-info", "--json=v1", "--installed")
    assert_match "Pinned homebrew/foo", cmd("tap-pin", "homebrew/foo")
    assert_match "homebrew/foo", cmd("tap", "--list-pinned")
    assert_match "Unpinned homebrew/foo", cmd("tap-unpin", "homebrew/foo")
    assert_match "Tapped", cmd("tap", "homebrew/bar", path/".git")
    assert_match "Untapped", cmd("untap", "homebrew/bar")
  ensure
    Tap::TAP_DIRECTORY.rmtree
  end

  def test_missing
    repo = CoreFormulaRepository.new
    foo_file = repo.formula_dir/"foo.rb"
    foo_file.write <<-EOS.undent
      class Foo < Formula
        url "https://example.com/foo-1.0"
      end
    EOS

    bar_file = repo.formula_dir/"bar.rb"
    bar_file.write <<-EOS.undent
      class Bar < Formula
        url "https://example.com/bar-1.0"
        depends_on "foo"
      end
    EOS

    (HOMEBREW_CELLAR/"bar/1.0").mkpath
    assert_match "foo", cmd("missing")
  ensure
    (HOMEBREW_CELLAR/"bar").rmtree
    foo_file.unlink
    bar_file.unlink
  end

  def test_doctor
    assert_match "This is an integration test",
                 cmd_fail("doctor", "check_integration_test")
  end

  def test_command
    assert_equal "#{HOMEBREW_LIBRARY_PATH}/cmd/info.rb",
                 cmd("command", "info")

    assert_match "Unknown command",
                 cmd_fail("command", "I-don't-exist")
  end

  def test_commands
    assert_match "Built-in commands",
                 cmd("commands")
  end

  def test_cat
    formula_file = CoreFormulaRepository.new.formula_dir/"testball.rb"
    content = <<-EOS.undent
      class Testball < Formula
        url "https://example.com/testball-0.1.tar.gz"
      end
    EOS
    formula_file.write content

    assert_equal content.chomp, cmd("cat", "testball")
  ensure
    formula_file.unlink
  end

  def test_desc
    formula_file = CoreFormulaRepository.new.formula_dir/"testball.rb"
    content = <<-EOS.undent
      class Testball < Formula
        desc "Some test"
        url "https://example.com/testball-0.1.tar.gz"
      end
    EOS
    formula_file.write content

    assert_equal "testball: Some test", cmd("desc", "testball")
  ensure
    formula_file.unlink
  end

  def test_edit
    (HOMEBREW_REPOSITORY/".git").mkpath
    formula_file = CoreFormulaRepository.new.formula_dir/"testball.rb"
    content = <<-EOS.undent
      class Testball < Formula
        url "https://example.com/testball-0.1.tar.gz"
        # something here
      end
    EOS
    formula_file.write content

    assert_match "# something here",
                 cmd("edit", "testball", {"HOMEBREW_EDITOR" => "/bin/cat"})
  ensure
    formula_file.unlink
    (HOMEBREW_REPOSITORY/".git").unlink
  end

  def test_sh
    assert_match "Your shell has been configured",
                 cmd("sh", {"SHELL" => "/usr/bin/true"})
  end

  def test_info
    formula_file = CoreFormulaRepository.new.formula_dir/"testball.rb"
    content = <<-EOS.undent
      class Testball < Formula
        url "https://example.com/testball-0.1.tar.gz"
      end
    EOS
    formula_file.write content

    assert_match "testball: stable 0.1",
                 cmd("info", "testball")
  ensure
    formula_file.unlink
  end

  def test_tap_readme
    (HOMEBREW_LIBRARY/"Taps").mkpath
    assert_match "brew install homebrew/foo/<formula>",
                 cmd("tap-readme", "foo", "--verbose")
    readme = HOMEBREW_LIBRARY/"Taps/homebrew/homebrew-foo/README.md"
    assert readme.exist?, "The README should be created"
  ensure
    (HOMEBREW_LIBRARY/"Taps").rmtree
  end

  def test_unpack
    formula_file = CoreFormulaRepository.new.formula_dir/"testball.rb"
    content = <<-EOS.undent
      class Testball < Formula
        url "file://#{File.expand_path("..", __FILE__)}/tarballs/testball-0.1.tbz"
      end
    EOS
    formula_file.write content

    mktmpdir do |path|
      cmd "unpack", "testball", "--destdir=#{path}"
      assert File.directory?("#{path}/testball-0.1"),
        "The tarball should be unpacked"
    end
  ensure
    FileUtils.rm_f (HOMEBREW_CACHE/"testball-0.1.tbz")
    formula_file.unlink
  end

  def test_options
    formula_file = CoreFormulaRepository.new.formula_dir/"testball.rb"
    content = <<-EOS.undent
      class Testball < Formula
        url "file://#{File.expand_path("..", __FILE__)}/tarballs/testball-0.1.tbz"
        option "with-foo", "foobar"
        depends_on "bar" => :recommended
      end
    EOS
    formula_file.write content

    assert_equal "--with-foo\n\tfoobar\n--without-bar\n\tBuild without bar support",
      cmd_output("options", "testball").chomp
  ensure
    formula_file.unlink
  end

  def test_outdated
    formula_file = CoreFormulaRepository.new.formula_dir/"testball.rb"
    content = <<-EOS.undent
      class Testball < Formula
        url "file://#{File.expand_path("..", __FILE__)}/tarballs/testball-0.1.tbz"
      end
    EOS
    formula_file.write content

    (HOMEBREW_CELLAR/"testball/0.0.1/foo").mkpath

    assert_equal "testball", cmd("outdated")
  ensure
    formula_file.unlink
    FileUtils.rm_rf HOMEBREW_CELLAR/"testball"
  end

  def test_upgrade
    formula_file = CoreFormulaRepository.new.formula_dir/"testball.rb"
    content = <<-EOS.undent
      class Testball < Formula
        url "file://#{File.expand_path("..", __FILE__)}/tarballs/testball-0.1.tbz"
        sha256 "#{TESTBALL_SHA256}"

        def install
          prefix.install Dir["*"]
        end
      end
    EOS
    formula_file.write content

    (HOMEBREW_CELLAR/"testball/0.0.1/foo").mkpath

    cmd("upgrade")
    assert (HOMEBREW_CELLAR/"testball/0.1").directory?,
      "The latest version directory should be created"
  ensure
    formula_file.unlink
    cmd("uninstall", "--force", testball)
    cmd("cleanup", "--force", "--prune=all")
  end

  def test_unlinkapps
    apps_dir = Pathname.new File.expand_path("~/Applications")
    apps_dir.mkpath

    formula_file = CoreFormulaRepository.new.formula_dir/"testball.rb"
    content = <<-EOS.undent
      class Testball < Formula
        url "https://example.com/testball-0.1.tar.gz"
      end
    EOS
    formula_file.write content

    source_app = (HOMEBREW_CELLAR/"testball/0.1/TestBall.app")
    source_app.mkpath

    FileUtils.ln_s source_app, "#{apps_dir}/TestBall.app"

    assert_match "Unlinking #{apps_dir}/TestBall.app",
      cmd("unlinkapps", "--local")
  ensure
    formula_file.unlink
    apps_dir.rmtree
    (HOMEBREW_CELLAR/"testball").rmtree
  end

  def test_pin_unpin
    formula_file = CoreFormulaRepository.new.formula_dir/"testball.rb"
    content = <<-EOS.undent
      class Testball < Formula
        url "file://#{File.expand_path("..", __FILE__)}/tarballs/testball-0.1.tbz"
        sha256 "#{TESTBALL_SHA256}"

        def install
          prefix.install Dir["*"]
        end
      end
    EOS
    formula_file.write content

    (HOMEBREW_CELLAR/"testball/0.0.1/foo").mkpath

    cmd("pin", "testball")
    cmd("upgrade")
    refute (HOMEBREW_CELLAR/"testball/0.1").directory?,
      "The latest version directory should NOT be created"

    cmd("unpin", "testball")
    cmd("upgrade")
    assert (HOMEBREW_CELLAR/"testball/0.1").directory?,
      "The latest version directory should be created"
  ensure
    formula_file.unlink
    cmd("uninstall", "--force", testball)
    cmd("cleanup", "--force", "--prune=all")
  end

  def test_custom_command
    mktmpdir do |path|
      cmd = "int-test-#{rand}"
      file = "#{path}/brew-#{cmd}"

      File.open(file, "w") { |f| f.write "#!/bin/sh\necho 'I am #{cmd}'\n" }
      FileUtils.chmod 0777, file

      assert_match "I am #{cmd}",
        cmd(cmd, {"PATH" => "#{path}#{File::PATH_SEPARATOR}#{ENV["PATH"]}"})
    end
  end
end
