require "testing_env"

class IntegrationCommandTests < Homebrew::TestCase
  def cmd_output(*args)
    cmd_args = %W[
      -W0
      -I#{HOMEBREW_LIBRARY_PATH}/test/lib
      -rconfig
    ]
    cmd_args << "-rsimplecov" if ENV["HOMEBREW_TESTS_COVERAGE"]
    cmd_args << (HOMEBREW_LIBRARY_PATH/"../brew.rb").resolved_path.to_s
    cmd_args += args
    Bundler.with_original_env do
      ENV["HOMEBREW_BREW_FILE"] = HOMEBREW_PREFIX/"bin/brew"
      ENV["HOMEBREW_INTEGRATION_TEST"] = args.join " "
      ENV["HOMEBREW_TEST_TMPDIR"] = TEST_TMPDIR
      Utils.popen_read(RUBY_PATH, *cmd_args).chomp
    end
  end

  def cmd(*args)
    output = cmd_output(*args)
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
end
