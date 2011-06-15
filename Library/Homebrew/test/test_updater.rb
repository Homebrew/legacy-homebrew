abort if ARGV.include? "--skip-update"

require 'testing_env'
HOMEBREW_CELLAR.mkpath

require 'extend/ARGV' # needs to be after test/unit to avoid conflict with OptionsParser
ARGV.extend(HomebrewArgvExtension)

require 'formula'
require 'utils'
require 'cmd/update'

class RefreshBrewMock < RefreshBrew
  def git_repo?
    @git_repo
  end
  attr_writer :git_repo

  def in_prefix_expect(cmd, output = '')
    @outputs  ||= Hash.new { |h,k| h[k] = [] }
    @expected ||= []
    @expected << cmd
    @outputs[cmd] << output
  end
  
  def `(cmd)
    if Dir.pwd == HOMEBREW_PREFIX.to_s and @expected.include?(cmd) and !@outputs[cmd].empty?
      @called ||= []
      @called << cmd
      @outputs[cmd].shift
    else
      raise "#{inspect} Unexpectedly called backticks in pwd `#{HOMEBREW_PREFIX}' and command `#{cmd}'"
    end
  end

  alias safe_system `
  
  def expectations_met?
    @expected == @called
  end
  
  def inspect
    "#<#{self.class.name} #{object_id}>"
  end
end

class UpdaterTests < Test::Unit::TestCase
  OUTSIDE_PREFIX = '/tmp'
  def outside_prefix
    Dir.chdir(OUTSIDE_PREFIX) { yield }
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

  def test_init_homebrew
    outside_prefix do
      updater = RefreshBrewMock.new
      updater.git_repo = false
      updater.in_prefix_expect("git init")
      updater.in_prefix_expect("git pull #{RefreshBrewMock::REPOSITORY_URL} master")
      updater.in_prefix_expect("git rev-parse HEAD", "1234abcd")
      
      assert_equal false, updater.update_from_masterbrew!
      assert updater.expectations_met?
      assert updater.updated_formulae.empty?
      assert updater.added_formulae.empty?
    end
  end

  def test_update_homebrew_without_any_changes
    outside_prefix do
      updater = RefreshBrewMock.new
      updater.git_repo = true
      updater.in_prefix_expect("git checkout -q master")
      updater.in_prefix_expect("git rev-parse HEAD", "1234abcd")
      updater.in_prefix_expect("git pull #{RefreshBrewMock::REPOSITORY_URL} master")
      updater.in_prefix_expect("git rev-parse HEAD", "3456cdef")
      updater.in_prefix_expect("git diff-tree -r --name-status -z 1234abcd 3456cdef", "")
      
      assert_equal false, updater.update_from_masterbrew!
      assert updater.expectations_met?
      assert updater.updated_formulae.empty?
      assert updater.added_formulae.empty?
    end
  end
  
  def test_update_homebrew_without_formulae_changes
    outside_prefix do
      updater = RefreshBrewMock.new
      updater.git_repo = true
      diff_output = fixture('update_git_diff_output_without_formulae_changes')

      updater.in_prefix_expect("git checkout -q master")
      updater.in_prefix_expect("git rev-parse HEAD", "1234abcd")
      updater.in_prefix_expect("git pull #{RefreshBrewMock::REPOSITORY_URL} master")
      updater.in_prefix_expect("git rev-parse HEAD", "3456cdef")
      updater.in_prefix_expect("git diff-tree -r --name-status -z 1234abcd 3456cdef", diff_output.gsub(/\s+/, "\0"))
      
      assert_equal true, updater.update_from_masterbrew!
      assert !updater.pending_formulae_changes?
      assert updater.updated_formulae.empty?
      assert updater.added_formulae.empty?
    end
  end
  
  def test_update_homebrew_with_formulae_changes
    outside_prefix do
      updater = RefreshBrewMock.new
      updater.git_repo = true
      diff_output = fixture('update_git_diff_output_with_formulae_changes')

      updater.in_prefix_expect("git checkout -q master")
      updater.in_prefix_expect("git rev-parse HEAD", "1234abcd")
      updater.in_prefix_expect("git pull #{RefreshBrewMock::REPOSITORY_URL} master")
      updater.in_prefix_expect("git rev-parse HEAD", "3456cdef")
      updater.in_prefix_expect("git diff-tree -r --name-status -z 1234abcd 3456cdef", diff_output.gsub(/\s+/, "\0"))
      
      assert_equal true, updater.update_from_masterbrew!
      assert updater.pending_formulae_changes?
      assert_equal %w{ xar yajl }, updater.updated_formulae
      assert_equal %w{ antiword bash-completion ddrescue dict lua }, updater.added_formulae
    end
  end
end
