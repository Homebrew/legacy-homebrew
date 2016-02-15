require "testing_env"
require "cmd/update-ruby"
require "formula_versions"
require "yaml"

class UpdaterTests < Homebrew::TestCase
  class UpdaterMock < ::Updater
    attr_accessor :diff, :expected, :called

    def initialize(*)
      super
      @outputs = Hash.new { |h, k| h[k] = [] }
      @expected = []
      @called = []
    end

    def in_repo_expect(cmd, output = "")
      @expected << cmd
      @outputs[cmd] << output
    end

    def `(*args)
      cmd = args.join(" ")
      if @expected.include?(cmd) && !@outputs[cmd].empty?
        @called << cmd
        @outputs[cmd].shift
      else
        raise "#{inspect} unexpectedly called backticks: `#{cmd}`"
      end
    end
    alias_method :safe_system, :`
    alias_method :system, :`

    def inspect
      "#<#{self.class.name}>"
    end
  end

  def fixture(name)
    self.class.fixture_data[name] || ""
  end

  def self.fixture_data
    @fixture_data ||= YAML.load_file("#{TEST_DIRECTORY}/fixtures/updater_fixture.yaml")
  end

  def setup
    @updater = UpdaterMock.new(HOMEBREW_REPOSITORY)
    @report = Report.new
  end

  def teardown
    FileUtils.rm_rf HOMEBREW_LIBRARY.join("Taps")
  end

  def perform_update(fixture_name = "")
    Formulary.stubs(:factory).returns(stub(:pkg_version => "1.0"))
    FormulaVersions.stubs(:new).returns(stub(:formula_at_revision => "2.0"))
    @updater.diff = fixture(fixture_name)
    @updater.in_repo_expect("git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null", "refs/remotes/origin/master")
    @updater.in_repo_expect("git symbolic-ref --short HEAD 2>/dev/null", "master")
    @updater.in_repo_expect("git status --untracked-files=all --porcelain 2>/dev/null", "")
    @updater.in_repo_expect("git rev-parse -q --verify HEAD", "1234abcd")
    @updater.in_repo_expect("git config core.autocrlf false")
    @updater.in_repo_expect("git pull --ff --no-rebase --quiet origin refs/heads/master:refs/remotes/origin/master")
    @updater.in_repo_expect("git rev-parse -q --verify HEAD", "3456cdef")
    @updater.pull!(:silent => true)
    @updater.in_repo_expect("git rev-parse -q --verify HEAD", "3456cdef")
    @report.update(@updater.report)
    assert_equal @updater.expected, @updater.called
  end

  def test_update_homebrew_without_any_changes
    perform_update
    assert_empty @report
  end

  def test_update_homebrew_without_formulae_changes
    perform_update("update_git_diff_output_without_formulae_changes")
    assert_empty @report.select_formula(:M)
    assert_empty @report.select_formula(:A)
    assert_empty @report.select_formula(:D)
  end

  def test_update_homebrew_with_formulae_changes
    perform_update("update_git_diff_output_with_formulae_changes")
    assert_equal %w[xar yajl], @report.select_formula(:M)
    assert_equal %w[antiword bash-completion ddrescue dict lua], @report.select_formula(:A)
  end

  def test_update_homebrew_with_removed_formulae
    perform_update("update_git_diff_output_with_removed_formulae")
    assert_equal %w[libgsasl], @report.select_formula(:D)
  end

  def test_update_homebrew_with_changed_filetype
    perform_update("update_git_diff_output_with_changed_filetype")
  end

  def test_update_homebrew_with_restructured_tap
    repo = HOMEBREW_LIBRARY.join("Taps", "foo", "bar")
    @updater = UpdaterMock.new(repo)
    repo.join("Formula").mkpath

    perform_update("update_git_diff_output_with_restructured_tap")

    assert_equal %w[foo/bar/git foo/bar/lua], @report.select_formula(:A)
    assert_empty @report.select_formula(:D)
  end

  def test_update_homebrew_simulate_homebrew_php_restructuring
    repo = HOMEBREW_LIBRARY.join("Taps", "foo", "bar")
    @updater = UpdaterMock.new(repo)
    repo.join("Formula").mkpath

    perform_update("update_git_diff_simulate_homebrew_php_restructuring")

    assert_empty @report.select_formula(:A)
    assert_equal %w[foo/bar/git foo/bar/lua], @report.select_formula(:D)
  end

  def test_update_homebrew_with_tap_formulae_changes
    repo = HOMEBREW_LIBRARY.join("Taps", "foo", "bar")
    @updater = UpdaterMock.new(repo)
    repo.join("Formula").mkpath

    perform_update("update_git_diff_output_with_tap_formulae_changes")

    assert_equal %w[foo/bar/lua], @report.select_formula(:A)
    assert_equal %w[foo/bar/git], @report.select_formula(:M)
    assert_empty @report.select_formula(:D)
  end
end
