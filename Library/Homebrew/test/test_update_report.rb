require "testing_env"
require "cmd/update-report"
require "formula_versions"
require "yaml"

class ReportTests < Homebrew::TestCase
  class ReporterMock < ::Reporter
    attr_accessor :diff, :expected, :called

    def initialize(repository)
      repo_var = Reporter.repository_variable(repository)
      ENV["HOMEBREW_UPDATE_BEFORE#{repo_var}"] = "abcdef12"
      ENV["HOMEBREW_UPDATE_AFTER#{repo_var}"] = "abcdef12"
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
    @updater = ReporterMock.new(HOMEBREW_REPOSITORY)
    @report = Report.new
  end

  def teardown
    FileUtils.rm_rf HOMEBREW_LIBRARY.join("Taps")
  end

  def perform_update(fixture_name = "")
    Formulary.stubs(:factory).returns(stub(:pkg_version => "1.0"))
    FormulaVersions.stubs(:new).returns(stub(:formula_at_revision => "2.0"))
    @updater.diff = fixture(fixture_name)
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

  def test_update_homebrew_with_changed_filetype
    perform_update("update_git_diff_output_with_changed_filetype")
  end

  def test_update_homebrew_with_restructured_tap
    repo = HOMEBREW_LIBRARY.join("Taps", "foo", "bar")
    @updater = ReporterMock.new(repo)
    repo.join("Formula").mkpath

    perform_update("update_git_diff_output_with_restructured_tap")
  end

  def test_update_homebrew_simulate_homebrew_php_restructuring
    repo = HOMEBREW_LIBRARY.join("Taps", "foo", "bar")
    @updater = ReporterMock.new(repo)
    repo.join("Formula").mkpath

    perform_update("update_git_diff_simulate_homebrew_php_restructuring")
  end

  def test_update_homebrew_with_tap_formulae_changes
    repo = HOMEBREW_LIBRARY.join("Taps", "foo", "bar")
    @updater = ReporterMock.new(repo)
    repo.join("Formula").mkpath

    perform_update("update_git_diff_output_with_tap_formulae_changes")
  end
end
