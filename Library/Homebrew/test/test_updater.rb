abort if ARGV.include? "--skip-update"

require 'testing_env'
require 'formula'
require 'rack'
require 'cmd/update'

class UpdaterMock < Updater
  def in_repo_expect(cmd, output = '')
    @outputs  ||= Hash.new { |h,k| h[k] = [] }
    @expected ||= []
    @expected << cmd
    @outputs[cmd] << output
  end

  def `(cmd, *args)
    cmd = "#{cmd} #{args*' '}".strip
    if @expected.include?(cmd) and !@outputs[cmd].empty?
      @called ||= []
      @called << cmd
      @outputs[cmd].shift
    else
      raise "#<#{self.class.name} #{object_id}> unexpectedly called backticks: `#{cmd}'"
    end
  end

  alias safe_system ` #`

  def expectations_met?
    @expected == @called
  end
end

class UpdaterTests < Test::Unit::TestCase
  def setup
    # UpdaterMock.in_repo_expect does not handle --verbose, so force it off
    @verbose = ARGV.verbose?
    class << ARGV
      def verbose?
        false
      end
    end

    # Now lets create some racks with kegs (versions)
    HOMEBREW_CELLAR.mkpath
    (Rack.factory('spam').path/'1.0'/'bin').mkpath
    (Rack.factory('xar').path/'0.1'/'lib').mkpath
    (Rack.factory('yajl').path/'42'/'bin').mkpath
    (Rack.factory('lua').path/'manula-diy-install'/'lib').mkpath
    (Rack.factory('shapelib').path/'0.1'/'lib').mkpath

    # Fake a formula (so outdated highlighting can be tested)
    (HOMEBREW_REPOSITORY+'Library/Formula/xar.rb').write <<-EOF.undent
      class Xar < Formula
        url "http://example.com/2.0"
      end
    EOF
    (HOMEBREW_REPOSITORY+'Library/Formula/yajl.rb').write <<-EOF.undent
      class Yajl < Formula
        url "http://example.com/42"
      end
    EOF
    (HOMEBREW_REPOSITORY+'Library/Formula/shapelib.rb').write <<-EOF.undent
      class Shapelib < Formula
        url "http://example.com/123"
      end
    EOF

  end

  def fixture(name)
    self.class.fixture_data[name]
  end

  def self.fixture_data
    unless @fixture_data
      require 'yaml'
      @fixture_data = YAML.load_file(Pathname.new(ABS__FILE__).parent.realpath + 'fixtures/updater_fixture.yaml')
    end
    @fixture_data
  end

  def test_update_homebrew_without_any_changes
    HOMEBREW_REPOSITORY.cd do
      updater = UpdaterMock.new
      updater.in_repo_expect("git checkout -q master")
      updater.in_repo_expect("git rev-parse -q --verify HEAD", "1234abcd")
      updater.in_repo_expect("git config core.autocrlf false")
      updater.in_repo_expect("git pull -q origin refs/heads/master:refs/remotes/origin/master")
      updater.in_repo_expect("git rev-parse -q --verify HEAD", "3456cdef")
      updater.in_repo_expect("git diff-tree -r --raw -M85% 1234abcd 3456cdef")
      updater.pull!
      report = Report.new
      report.merge!(updater.report)

      assert updater.expectations_met?
      assert report.empty?
    end
  end

  def test_update_homebrew_without_formulae_changes
    diff_output = fixture('update_git_diff_output_without_formulae_changes')

    HOMEBREW_REPOSITORY.cd do
      updater = UpdaterMock.new
      updater.in_repo_expect("git checkout -q master")
      updater.in_repo_expect("git rev-parse -q --verify HEAD", "1234abcd")
      updater.in_repo_expect("git config core.autocrlf false")
      updater.in_repo_expect("git pull -q origin refs/heads/master:refs/remotes/origin/master")
      updater.in_repo_expect("git rev-parse -q --verify HEAD", "3456cdef")
      updater.in_repo_expect("git diff-tree -r --raw -M85% 1234abcd 3456cdef", diff_output)
      updater.pull!
      report = Report.new
      report.merge!(updater.report)

      assert updater.expectations_met?
      assert report.select_formula(:M).empty?
      assert report.select_formula(:A).empty?
      assert report.select_formula(:R).empty?
    end
  end

  def test_update_homebrew_with_formulae_changes
    diff_output = fixture('update_git_diff_output_with_formulae_changes')
    # Additionally test the dump (for color output)
    stdout_fake = StdoutFake.new

    HOMEBREW_REPOSITORY.cd do
      updater = UpdaterMock.new
      updater.in_repo_expect("git checkout -q master")
      updater.in_repo_expect("git rev-parse -q --verify HEAD", "1234abcd")
      updater.in_repo_expect("git config core.autocrlf false")
      updater.in_repo_expect("git pull -q origin refs/heads/master:refs/remotes/origin/master")
      updater.in_repo_expect("git rev-parse -q --verify HEAD", "3456cdef")
      updater.in_repo_expect("git diff-tree -r --raw -M85% 1234abcd 3456cdef", diff_output)
      updater.pull!
      report = Report.new
      report.merge!(updater.report)

      assert updater.expectations_met?
      assert_equal %w{ xar yajl }, report.select_formula(:M)
      assert_equal %w{ antiword bash-completion ddrescue dict lua }, report.select_formula(:A)
      assert_equal %w{ shapelib }, report.select_formula(:R)
    end
  end

  def test_update_dump_with_formulae_changes
    diff_output = fixture('update_git_diff_output_with_formulae_changes')

    HOMEBREW_REPOSITORY.cd do
      updater = UpdaterMock.new
      updater.in_repo_expect("git checkout -q master")
      updater.in_repo_expect("git rev-parse -q --verify HEAD", "1234abcd")
      updater.in_repo_expect("git config core.autocrlf false")
      updater.in_repo_expect("git pull -q origin refs/heads/master:refs/remotes/origin/master")
      updater.in_repo_expect("git rev-parse -q --verify HEAD", "3456cdef")
      updater.in_repo_expect("git diff-tree -r --raw -M85% 1234abcd 3456cdef", diff_output)
      updater.pull!
      report = Report.new
      report.merge!(updater.report)

      assert_equal %w{ xar yajl }, report.select_formula(:M)
      assert_equal %w{ antiword bash-completion ddrescue dict lua }, report.select_formula(:A)
      assert_equal %w{ shapelib }, report.select_formula(:R)

      stdout_fake = StdoutFake.new
      stdout_orig = $stdout.clone
      $stdout = stdout_fake
      report.dump
      $stdout = stdout_orig

      if @verbose
        # Just in case you want to see it. I don't know how to deferr this
        # to the end of all tests.
        stdout_fake.seek 0
        puts stdout_fake.read
      end
    end
  end

  def teardown
    # Let's have this last safty net
    if HOMEBREW_CELLAR.to_s.start_with? '/usr'
      raise "Now that was close! I am not going to delete anything in /usr"
    else
       HOMEBREW_CELLAR.rmtree if HOMEBREW_CELLAR.exist?
       HOMEBREW_REPOSITORY.rmtree if HOMEBREW_REPOSITORY.exist?
    end
  end
end
