require 'testing_env'
require 'cmd/update'
require 'yaml'

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
  def fixture(name)
    self.class.fixture_data[name]
  end

  def self.fixture_data
    @fixture_data ||= load_fixture_data
  end

  def self.load_fixture_data
    YAML.load_file(Pathname.new(ABS__FILE__).parent.realpath + 'fixtures/updater_fixture.yaml')
  end

  def setup
    @updater = UpdaterMock.new
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
    assert @updater.expectations_met?
    assert @report.empty?
  end

  def test_update_homebrew_without_formulae_changes
    perform_update(fixture('update_git_diff_output_without_formulae_changes'))
    assert @updater.expectations_met?
    assert @report.select_formula(:M).empty?
    assert @report.select_formula(:A).empty?
    assert @report.select_formula(:R).empty?
  end

  def test_update_homebrew_with_formulae_changes
    perform_update(fixture('update_git_diff_output_with_formulae_changes'))
    assert @updater.expectations_met?
    assert_equal %w{ xar yajl }, @report.select_formula(:M)
    assert_equal %w{ antiword bash-completion ddrescue dict lua }, @report.select_formula(:A)
    assert_equal %w{ shapelib }, @report.select_formula(:R)
  end

  def test_update_homebrew_with_tapped_formula_changes
    perform_update(fixture('update_git_diff_output_with_tapped_formulae_changes'))
    assert @updater.expectations_met?
    assert_equal [
      Pathname('someuser-sometap/Formula/antiword.rb'),
      Pathname('someuser-sometap/HomebrewFormula/lua.rb'),
      Pathname('someuser-sometap/custom-formula.rb'),
    ], @report.tapped_formula_for(:A)
  end
end
