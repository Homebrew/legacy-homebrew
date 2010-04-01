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

  def test_update_homebrew_without_any_changes
    outside_prefix do
      updater = RefreshBrewMock.new
      updater.in_prefix_expect("git checkout master")
      updater.in_prefix_expect("git pull origin master", "Already up-to-date.\n")
      
      assert_equal false, updater.update_from_masterbrew!
      assert updater.expectations_met?
      assert updater.updated_formulae.empty?
      assert updater.added_formulae.empty?
    end
  end
  
  def test_update_homebrew_without_formulae_changes
    outside_prefix do
      updater = RefreshBrewMock.new
      updater.in_prefix_expect("git checkout master")
      output = fixture('update_git_pull_output_without_formulae_changes')
      updater.in_prefix_expect("git pull origin master", output)
      
      assert_equal true, updater.update_from_masterbrew!
      assert !updater.pending_formulae_changes?
      assert updater.updated_formulae.empty?
      assert updater.added_formulae.empty?
    end
  end
  
  def test_update_homebrew_with_formulae_changes
    outside_prefix do
      updater = RefreshBrewMock.new
      updater.in_prefix_expect("git checkout master")
      output = fixture('update_git_pull_output_with_formulae_changes')
      updater.in_prefix_expect("git pull origin master", output)
      
      assert_equal true, updater.update_from_masterbrew!
      assert updater.pending_formulae_changes?
      assert_equal %w{ xar yajl }, updater.updated_formulae
      assert_equal %w{ antiword bash-completion ddrescue dict lua }, updater.added_formulae
    end
  end
  
  def test_updater_returns_current_revision
    outside_prefix do
      updater = RefreshBrewMock.new
      updater.in_prefix_expect('git log -l -1 --pretty=format:%H', 'the-revision-hash')
      assert_equal 'the-revision-hash', updater.current_revision
    end
  end
end
