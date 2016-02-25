require "testing_env"
require "cmd/update-report"
require "formula_versions"
require "yaml"

class ReportTests < Homebrew::TestCase
  class ReporterMock < ::Reporter
    attr_accessor :diff

    def initialize(tap, init_rev, cur_rev)
      @tap = tap
      ENV["HOMEBREW_UPDATE_BEFORE#{repo_var}"] = init_rev
      ENV["HOMEBREW_UPDATE_AFTER#{repo_var}"] = cur_rev
      super(tap)
    end
  end

  def fixture(name)
    self.class.fixture_data[name] || ""
  end

  def self.fixture_data
    @fixture_data ||= YAML.load_file("#{TEST_DIRECTORY}/fixtures/updater_fixture.yaml")
  end

  def setup
    @tap = CoreFormulaRepository.new
    @reporter = ReporterMock.new(@tap, "12345678", "abcdef12")
    @hub = ReporterHub.new
  end

  def teardown
    FileUtils.rm_rf HOMEBREW_LIBRARY.join("Taps")
  end

  def perform_update(fixture_name = "")
    Formulary.stubs(:factory).returns(stub(:pkg_version => "1.0"))
    FormulaVersions.stubs(:new).returns(stub(:formula_at_revision => "2.0"))
    @reporter.diff = fixture(fixture_name)
    @hub.add(@reporter) if @reporter.updated?
  end

  def test_update_report_without_revision_var
    assert_raises(Reporter::ReporterRevisionUnsetError) { ReporterMock.new(@tap, nil, nil) }
  end

  def test_update_homebrew_without_any_changes
    perform_update
    assert_empty @hub
  end

  def test_update_homebrew_without_formulae_changes
    perform_update("update_git_diff_output_without_formulae_changes")
    assert_empty @hub.select_formula(:M)
    assert_empty @hub.select_formula(:A)
    assert_empty @hub.select_formula(:D)
  end

  def test_update_homebrew_with_formulae_changes
    perform_update("update_git_diff_output_with_formulae_changes")
    assert_equal %w[xar yajl], @hub.select_formula(:M)
    assert_equal %w[antiword bash-completion ddrescue dict lua], @hub.select_formula(:A)
  end

  def test_update_homebrew_with_removed_formulae
    perform_update("update_git_diff_output_with_removed_formulae")
    assert_equal %w[libgsasl], @hub.select_formula(:D)
  end

  def test_update_homebrew_with_changed_filetype
    perform_update("update_git_diff_output_with_changed_filetype")
    assert_equal %w[elixir], @hub.select_formula(:M)
    assert_equal %w[libbson], @hub.select_formula(:A)
    assert_equal %w[libgsasl], @hub.select_formula(:D)
  end

  def test_update_homebrew_with_formula_rename
    @tap.stubs(:formula_renames).returns("cv" => "progress")
    perform_update("update_git_diff_output_with_formula_rename")
    assert_empty @hub.select_formula(:A)
    assert_empty @hub.select_formula(:D)
    assert_equal [["cv", "progress"]], @hub.select_formula(:R)
  end

  def test_update_homebrew_with_restructured_tap
    tap = Tap.new("foo", "bar")
    @reporter = ReporterMock.new(tap, "12345678", "abcdef12")
    tap.path.join("Formula").mkpath

    perform_update("update_git_diff_output_with_restructured_tap")
    assert_equal %w[foo/bar/git foo/bar/lua], @hub.select_formula(:A)
    assert_empty @hub.select_formula(:D)
  end

  def test_update_homebrew_simulate_homebrew_php_restructuring
    tap = Tap.new("foo", "bar")
    @reporter = ReporterMock.new(tap, "12345678", "abcdef12")
    tap.path.join("Formula").mkpath

    perform_update("update_git_diff_simulate_homebrew_php_restructuring")
    assert_empty @hub.select_formula(:A)
    assert_equal %w[foo/bar/git foo/bar/lua], @hub.select_formula(:D)
  end

  def test_update_homebrew_with_tap_formulae_changes
    tap = Tap.new("foo", "bar")
    @reporter = ReporterMock.new(tap, "12345678", "abcdef12")
    tap.path.join("Formula").mkpath

    perform_update("update_git_diff_output_with_tap_formulae_changes")
    assert_equal %w[foo/bar/lua], @hub.select_formula(:A)
    assert_equal %w[foo/bar/git], @hub.select_formula(:M)
    assert_empty @hub.select_formula(:D)
  end
end
