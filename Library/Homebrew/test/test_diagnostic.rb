require "testing_env"
require "fileutils"
require "pathname"
require "diagnostic"

class DiagnosticChecksTest < Homebrew::TestCase
  def setup
    @env = ENV.to_hash
    @checks = Homebrew::Diagnostic::Checks.new
  end

  def teardown
    ENV.replace(@env)
  end

  def test_inject_file_list
    assert_equal "foo:\n",
      @checks.inject_file_list([], "foo:\n")
    assert_equal "foo:\n    /a\n    /b\n",
      @checks.inject_file_list(%w[/a /b], "foo:\n")
  end

  def test_check_path_for_trailing_slashes
    ENV["PATH"] += File::PATH_SEPARATOR + "/foo/bar/"
    assert_match "Some directories in your path end in a slash",
      @checks.check_path_for_trailing_slashes
  end

  def test_check_for_anaconda
    mktmpdir do |path|
      anaconda = "#{path}/anaconda"
      python = "#{path}/python"
      FileUtils.touch anaconda
      File.open(python, "w") do |file|
        file.write("#! #{`which bash`}\necho -n '#{python}'\n")
      end
      FileUtils.chmod 0755, anaconda
      FileUtils.chmod 0755, python

      ENV["PATH"] = path + File::PATH_SEPARATOR + ENV["PATH"]

      assert_match "Anaconda",
        @checks.check_for_anaconda
    end
  end

  def test_check_for_other_package_managers
    MacOS.stubs(:macports_or_fink).returns ["fink"]
    assert_match "You have MacPorts or Fink installed:",
      @checks.check_for_other_package_managers
  end

  def test_check_for_unsupported_osx
    ARGV.stubs(:homebrew_developer?).returns false
    OS::Mac.stubs(:prerelease?).returns true
    assert_match "We do not provide support for this pre-release version.",
      @checks.check_for_unsupported_osx
  end

  def test_check_access_homebrew_repository
    mod = HOMEBREW_REPOSITORY.stat.mode & 0777
    HOMEBREW_REPOSITORY.chmod 0555

    assert_match "The #{HOMEBREW_REPOSITORY} is not writable.",
      @checks.check_access_homebrew_repository
  ensure
    HOMEBREW_REPOSITORY.chmod mod
  end

  def test_check_access_logs
    mod = HOMEBREW_LOGS.stat.mode & 0777
    HOMEBREW_LOGS.chmod 0555

    assert_match "#{HOMEBREW_LOGS} isn't writable.",
      @checks.check_access_logs
  ensure
    HOMEBREW_LOGS.chmod mod
  end

  def test_check_access_cache
    mod = HOMEBREW_CACHE.stat.mode & 0777
    HOMEBREW_CACHE.chmod 0555
    assert_match "#{HOMEBREW_CACHE} isn't writable.",
      @checks.check_access_cache
  ensure
    HOMEBREW_CACHE.chmod mod
  end

  def test_check_access_cellar
    mod = HOMEBREW_CELLAR.stat.mode & 0777
    HOMEBREW_CELLAR.chmod 0555

    assert_match "#{HOMEBREW_CELLAR} isn't writable.",
      @checks.check_access_cellar
  ensure
    HOMEBREW_CELLAR.chmod mod
  end

  def test_check_access_prefix_opt
    opt = HOMEBREW_PREFIX.join("opt")
    opt.mkpath
    opt.chmod 0555

    assert_match "#{opt} isn't writable.",
      @checks.check_access_prefix_opt
  ensure
    opt.unlink
  end

  def test_check_homebrew_prefix
    # the integration tests are run in a special prefix
    assert_match "Your Homebrew is not installed to /usr/local",
      @checks.check_homebrew_prefix
  end

  def test_check_user_path_usr_bin_before_homebrew
    bin = HOMEBREW_PREFIX/"bin"
    sep = File::PATH_SEPARATOR
    # ensure /usr/bin is before HOMEBREW_PREFIX/bin in the PATH
    ENV["PATH"] = "/usr/bin#{sep}#{bin}#{sep}" +
      ENV["PATH"].gsub(%r{(?:^|#{sep})(?:/usr/bin|#{bin})}, "")

    # ensure there's at least one file with the same name in both /usr/bin/ and
    # HOMEBREW_PREFIX/bin/
    (bin/"#{File.basename Dir["/usr/bin/*"].first}").mkpath

    assert_match "/usr/bin occurs before #{HOMEBREW_PREFIX}/bin",
      @checks.check_user_path_1
  ensure
    bin.rmtree
  end

  def test_check_user_path_bin
    ENV["PATH"] = ENV["PATH"].gsub \
      %r{(?:^|#{File::PATH_SEPARATOR})#{HOMEBREW_PREFIX}/bin}, ""

    assert_nil @checks.check_user_path_1
    assert_match "Homebrew's bin was not found in your PATH.",
      @checks.check_user_path_2
  end

  def test_check_user_path_sbin
    sbin = HOMEBREW_PREFIX/"sbin"
    ENV["PATH"] = "#{HOMEBREW_PREFIX}/bin#{File::PATH_SEPARATOR}" +
      ENV["PATH"].gsub(%r{(?:^|#{File::PATH_SEPARATOR})#{sbin}}, "")
    (sbin/"something").mkpath

    assert_nil @checks.check_user_path_1
    assert_nil @checks.check_user_path_2
    assert_match "Homebrew's sbin was not found in your PATH",
      @checks.check_user_path_3
  ensure
    sbin.rmtree
  end

  def test_check_user_curlrc
    mktmpdir do |path|
      FileUtils.touch "#{path}/.curlrc"
      ENV["CURL_HOME"] = path

      assert_match "You have a curlrc file",
        @checks.check_user_curlrc
    end
  end

  def test_check_for_unsupported_curl_vars
    MacOS.stubs(:version).returns OS::Mac::Version.new("10.10")
    ENV["SSL_CERT_DIR"] = "/some/path"

    assert_match "SSL_CERT_DIR support was removed from Apple's curl.",
      @checks.check_for_unsupported_curl_vars
  end

  def test_check_for_config_scripts
    mktmpdir do |path|
      file = "#{path}/foo-config"
      FileUtils.touch file
      FileUtils.chmod 0755, file
      ENV["PATH"] = "#{path}#{File::PATH_SEPARATOR}#{ENV["PATH"]}"

      assert_match %("config" scripts exist),
        @checks.check_for_config_scripts
    end
  end

  def test_check_DYLD_vars
    ENV["DYLD_INSERT_LIBRARIES"] = "foo"
    assert_match "Setting DYLD_INSERT_LIBRARIES",
      @checks.check_DYLD_vars
  end

  def test_check_for_symlinked_cellar
    HOMEBREW_CELLAR.rmtree

    mktmpdir do |path|
      FileUtils.ln_s path, HOMEBREW_CELLAR

      assert_match path,
        @checks.check_for_symlinked_cellar
    end

  ensure
    HOMEBREW_CELLAR.unlink
    HOMEBREW_CELLAR.mkpath
  end

  def test_check_for_autoconf
    MacOS::Xcode.stubs(:installed?).returns true
    MacOS::Xcode.stubs(:provides_autotools?).returns true
    mktmpdir do |path|
      file = "#{path}/autoconf"
      FileUtils.touch file
      FileUtils.chmod 0755, file
      ENV["PATH"] = [path, ENV["PATH"]].join File::PATH_SEPARATOR

      assert_match "This custom autoconf",
        @checks.check_for_autoconf
    end
  end

  def test_check_tmpdir
    ENV["TMPDIR"] = "/i/don/t/exis/t"
    assert_match "doesn't exist",
      @checks.check_tmpdir
  end

  def test_check_for_external_cmd_name_conflict
    mktmpdir do |path1|
      mktmpdir do |path2|
        [path1, path2].each do |path|
          cmd = "#{path}/brew-foo"
          FileUtils.touch cmd
          FileUtils.chmod 0755, cmd
        end

        ENV["PATH"] = [path1, path2, ENV["PATH"]].join File::PATH_SEPARATOR

        assert_match "brew-foo",
          @checks.check_for_external_cmd_name_conflict
      end
    end
  end
end
