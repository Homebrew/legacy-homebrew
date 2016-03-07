require "testing_env"

class TapTest < Homebrew::TestCase
  include FileUtils

  def setup
    @path = Tap::TAP_DIRECTORY/"homebrew/homebrew-foo"
    @path.mkpath
    @tap = Tap.new("Homebrew", "foo")
  end

  def setup_tap_files
    @formula_file = @path/"Formula/foo.rb"
    @formula_file.write <<-EOS.undent
      class Foo < Formula
        url "https://example.com/foo-1.0.tar.gz"
      end
    EOS
    @alias_file = @path/"Aliases/bar"
    @alias_file.parent.mkpath
    ln_s @formula_file, @alias_file
    (@path/"formula_renames.json").write <<-EOS.undent
     { "oldname": "foo" }
    EOS
    (@path/"tap_migrations.json").write <<-EOS.undent
     { "removed-formula": "homebrew/foo" }
    EOS
    @cmd_file = @path/"cmd/brew-tap-cmd.rb"
    @cmd_file.parent.mkpath
    touch @cmd_file
    chmod 0755, @cmd_file
    @manpage_file = @path/"man/man1/brew-tap-cmd.1"
    @manpage_file.parent.mkpath
    touch @manpage_file
  end

  def setup_git_repo
    env = ENV.to_hash
    %w[AUTHOR COMMITTER].each do |role|
      ENV["GIT_#{role}_NAME"] = "brew tests"
      ENV["GIT_#{role}_EMAIL"] = "brew-tests@localhost"
      ENV["GIT_#{role}_DATE"] = "Thu May 21 00:04:11 2009 +0100"
    end

    @path.cd do
      shutup do
        system "git", "init"
        system "git", "remote", "add", "origin", "https://github.com/Homebrew/homebrew-foo"
        system "git", "add", "--all"
        system "git", "commit", "-m", "init"
      end
    end
  ensure
    ENV.replace(env)
  end

  def teardown
    Tap::TAP_DIRECTORY.rmtree
  end

  def test_fetch
    assert_kind_of CoreTap, Tap.fetch("Homebrew", "homebrew")
    tap = Tap.fetch("Homebrew", "foo")
    assert_kind_of Tap, tap
    assert_equal "homebrew/foo", tap.name
  ensure
    Tap.clear_cache
  end

  def test_names
    assert_equal ["homebrew/foo"], Tap.names
  end

  def test_attributes
    assert_equal "Homebrew", @tap.user
    assert_equal "foo", @tap.repo
    assert_equal "homebrew/foo", @tap.name
    assert_equal @path, @tap.path
    assert_predicate @tap, :installed?
    assert_predicate @tap, :official?
    refute_predicate @tap, :core_tap?
  end

  def test_issues_url
    t = Tap.new("someone", "foo")
    path = Tap::TAP_DIRECTORY/"someone/homebrew-foo"
    path.mkpath
    cd path do
      shutup { system "git", "init" }
      system "git", "remote", "add", "origin",
        "https://github.com/someone/homebrew-foo"
    end
    assert_equal "https://github.com/someone/homebrew-foo/issues", t.issues_url
    assert_equal "https://github.com/Homebrew/homebrew-foo/issues", @tap.issues_url

    (Tap::TAP_DIRECTORY/"someone/homebrew-no-git").mkpath
    assert_nil Tap.new("someone", "no-git").issues_url
  end

  def test_files
    setup_tap_files

    assert_equal [@formula_file], @tap.formula_files
    assert_equal ["homebrew/foo/foo"], @tap.formula_names
    assert_equal [@alias_file], @tap.alias_files
    assert_equal ["homebrew/foo/bar"], @tap.aliases
    assert_equal @tap.alias_table, "homebrew/foo/bar" => "homebrew/foo/foo"
    assert_equal @tap.alias_reverse_table, "homebrew/foo/foo" => ["homebrew/foo/bar"]
    assert_equal @tap.formula_renames, "oldname" => "foo"
    assert_equal @tap.tap_migrations, "removed-formula" => "homebrew/foo"
    assert_equal [@cmd_file], @tap.command_files
    assert_kind_of Hash, @tap.to_hash
    assert_equal true, @tap.formula_file?(@formula_file)
    assert_equal true, @tap.formula_file?("Formula/foo.rb")
    assert_equal false, @tap.formula_file?("bar.rb")
    assert_equal false, @tap.formula_file?("Formula/baz.sh")
  end

  def test_remote
    setup_git_repo

    assert_equal "https://github.com/Homebrew/homebrew-foo", @tap.remote
    assert_raises(TapUnavailableError) { Tap.new("Homebrew", "bar").remote }
    refute_predicate @tap, :custom_remote?

    version_tap = Tap.new("Homebrew", "versions")
    version_tap.path.mkpath
    version_tap.path.cd do
      shutup do
        system "git", "init"
        system "git", "remote", "add", "origin", "https://github.com/Homebrew/homebrew-versions"
      end
    end
    refute_predicate version_tap, :private?
  end

  def test_remote_not_git_repo
    assert_nil @tap.remote
  end

  def test_remote_git_not_available
    setup_git_repo
    Utils.stubs(:git_available?).returns(false)
    assert_nil @tap.remote
  end

  def test_git_variant
    touch @path/"README"
    setup_git_repo

    assert_equal "e1893a6bd191ba895c71b652ff8376a6114c7fa7", @tap.git_head
    assert_equal "e189", @tap.git_short_head
    assert_match %r{years ago}, @tap.git_last_commit
    assert_equal "2009-05-21", @tap.git_last_commit_date
  end

  def test_private_remote
    skip "HOMEBREW_GITHUB_API_TOKEN is required" unless ENV["HOMEBREW_GITHUB_API_TOKEN"]
    assert_predicate @tap, :private?
  end

  def test_install_tap_already_tapped_error
    assert_raises(TapAlreadyTappedError) { @tap.install }
  end

  def test_uninstall_tap_unavailable_error
    tap = Tap.new("Homebrew", "bar")
    assert_raises(TapUnavailableError) { tap.uninstall }
  end

  def test_install_git_error
    tap = Tap.new("user", "repo")
    assert_raises(ErrorDuringExecution) do
      shutup { tap.install :clone_target => "file:///not/existed/remote/url" }
    end
    refute_predicate tap, :installed?
    refute_predicate Tap::TAP_DIRECTORY/"user", :exist?
  end

  def test_install_and_uninstall
    setup_tap_files
    setup_git_repo

    tap = Tap.new("Homebrew", "bar")
    shutup { tap.install :clone_target => @tap.path/".git" }
    assert_predicate tap, :installed?
    assert_predicate HOMEBREW_PREFIX/"share/man/man1/brew-tap-cmd.1", :file?
    shutup { tap.uninstall }
    refute_predicate tap, :installed?
    refute_predicate HOMEBREW_PREFIX/"share/man/man1/brew-tap-cmd.1", :exist?
    refute_predicate HOMEBREW_PREFIX/"share/man/man1", :exist?
  ensure
    (HOMEBREW_PREFIX/"share").rmtree
  end

  def test_pin_and_unpin
    refute_predicate @tap, :pinned?
    assert_raises(TapPinStatusError) { @tap.unpin }
    @tap.pin
    assert_predicate @tap, :pinned?
    assert_raises(TapPinStatusError) { @tap.pin }
    @tap.unpin
    refute_predicate @tap, :pinned?
  end
end

class CoreTapTest < Homebrew::TestCase
  include FileUtils

  def setup
    @repo = CoreTap.new
  end

  def test_attributes
    assert_equal "Homebrew", @repo.user
    assert_equal "homebrew", @repo.repo
    assert_equal "Homebrew/homebrew", @repo.name
    assert_equal [], @repo.command_files
    assert_predicate @repo, :installed?
    refute_predicate @repo, :pinned?
    assert_predicate @repo, :official?
    assert_predicate @repo, :core_tap?
  end

  def test_forbidden_operations
    assert_raises(RuntimeError) { @repo.uninstall }
    assert_raises(RuntimeError) { @repo.pin }
    assert_raises(RuntimeError) { @repo.unpin }
  end

  def test_files
    @formula_file = @repo.formula_dir/"foo.rb"
    @formula_file.write <<-EOS.undent
      class Foo < Formula
        url "https://example.com/foo-1.0.tar.gz"
      end
    EOS
    @alias_file = @repo.alias_dir/"bar"
    @alias_file.parent.mkpath
    ln_s @formula_file, @alias_file

    assert_equal [@formula_file], @repo.formula_files
    assert_equal ["foo"], @repo.formula_names
    assert_equal [@alias_file], @repo.alias_files
    assert_equal ["bar"], @repo.aliases
    assert_equal @repo.alias_table, "bar" => "foo"
    assert_equal @repo.alias_reverse_table, "foo" => ["bar"]
  ensure
    @formula_file.unlink
    @repo.alias_dir.rmtree
  end
end
