require 'testing_env'
require 'cmd/update'
require 'yaml'

class UpdaterTests < Homebrew::TestCase
  class UpdaterMock < ::Updater
    def initialize(*)
      super
      @outputs = Hash.new { |h, k| h[k] = [] }
      @expected = []
      @called = []
    end

    def in_repo_expect(cmd, output = '')
      @expected << cmd
      @outputs[cmd] << output
    end

    def `(*args)
      cmd = args.join(" ")
      if @expected.include?(cmd) and !@outputs[cmd].empty?
        @called << cmd
        @outputs[cmd].shift
      else
        raise "#{inspect} unexpectedly called backticks: `#{cmd}`"
      end
    end
    alias_method :safe_system, :`

    def expectations_met?
      @expected == @called
    end
  end

  def fixture(name)
    self.class.fixture_data[name]
  end

  def self.fixture_data
    @fixture_data ||= YAML.load_file("#{TEST_DIRECTORY}/fixtures/updater_fixture.yaml")
  end

  def setup
    @updater = UpdaterMock.new(HOMEBREW_REPOSITORY)
    @report = Report.new
  end

  def perform_update(diff_output="")
    HOMEBREW_REPOSITORY.cd do
      @updater.in_repo_expect("git checkout -q master")
      @updater.in_repo_expect("git rev-parse -q --verify HEAD", "1234abcd")
      @updater.in_repo_expect("git config core.autocrlf false")
      @updater.in_repo_expect("git pull -q origin refs/heads/master:refs/remotes/origin/master")
      @updater.in_repo_expect("git rev-parse -q --verify HEAD", "3456cdef")
      @updater.in_repo_expect("git diff-tree -r --raw -M85% 1234abcd 3456cdef", diff_output)
      @updater.pull!
      @report.merge!(@updater.report)
    end
  end

  def test_update_homebrew_without_any_changes
    perform_update
    assert_predicate @updater, :expectations_met?
    assert_empty @report
  end

  def test_update_homebrew_without_formulae_changes
    perform_update(fixture('update_git_diff_output_without_formulae_changes'))
    assert_predicate @updater, :expectations_met?
    assert_empty @report.select_formula(:M)
    assert_empty @report.select_formula(:A)
    assert_empty @report.select_formula(:R)
  end

  def test_update_homebrew_with_formulae_changes
    perform_update(fixture('update_git_diff_output_with_formulae_changes'))
    assert_predicate @updater, :expectations_met?
    assert_equal %w{ xar yajl }, @report.select_formula(:M)
    assert_equal %w{ antiword bash-completion ddrescue dict lua }, @report.select_formula(:A)
    assert_equal %w{ shapelib }, @report.select_formula(:R)
  end

  def test_update_homebrew_with_tapped_formula_changes
    perform_update(fixture('update_git_diff_output_with_tapped_formulae_changes'))
    assert_predicate @updater, :expectations_met?
    assert_equal [
      HOMEBREW_LIBRARY.join("Taps", "someuser/sometap/Formula/antiword.rb"),
      HOMEBREW_LIBRARY.join("Taps", "someuser/sometap/HomebrewFormula/lua.rb"),
      HOMEBREW_LIBRARY.join("Taps", "someuser/sometap/custom-formula.rb"),
    ], @report.tapped_formula_for(:A)
  end

  def test_update_homebrew_with_removed_formulae
    perform_update(fixture('update_git_diff_output_with_removed_formulae'))
    assert_predicate @updater, :expectations_met?
    assert_equal %w{libgsasl}, @report.select_formula(:D)
  end

  def test_update_homebrew_with_changed_filetype
    perform_update(fixture('update_git_diff_output_with_changed_filetype'))
    assert_predicate @updater, :expectations_met?
  end
end
