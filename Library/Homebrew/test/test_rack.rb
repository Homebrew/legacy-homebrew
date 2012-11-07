require 'testing_env'
require 'test/testball'
require 'rack'
require 'stringio'

class EmptyRackTest < Test::Unit::TestCase
  def setup
    HOMEBREW_CELLAR.mkpath
  end

  def test_rack_all
    assert Rack.all, []
  end

  def test_rack_valid_but_not_existing
    assert_raise RuntimeError do
      Rack.new(HOMEBREW_CELLAR/'here is no space for you')
    end
    assert_raise RuntimeError do
      Rack.new(HOMEBREW_CELLAR/'BIG')
    end
    # But this should be fine:
    Rack.new(HOMEBREW_CELLAR/'__UNKNOWN__')
    assert_raise RuntimeError do
      Rack.new(HOMEBREW_PREFIX/'nothere')
    end
    assert_raise RuntimeError do
      Rack.new(HOMEBREW_CELLAR/'also'/'nothere')
    end
    r = Rack.new(HOMEBREW_CELLAR/'thisisvalid')
    assert r.valid?
    assert_raise RuntimeError do
      r.real?
    end
  end

  def test_rack_factory
    assert_equal Rack.factory('spam'), Rack.new(HOMEBREW_CELLAR/'spam')
  end

  def test_fname
    name = 'eggs'
    fname = Rack.factory(name).fname
    assert fname.is_a?(String)
    assert_equal fname, name
    assert_equal Rack.factory(name).fname, Rack.factory(name).path.basename.to_s
  end

  def teardown
    HOMEBREW_CELLAR.rmtree
  end
end


class RackTests < Test::Unit::TestCase
  def setup
    @formula = TestBall.new
    shutup do
      @formula.brew { @formula.install }
    end

    # Create some different racks with kegs for a nice breakfast.
    # Eventually, we might want something like this in testing_env.
    (Rack.factory('spam').path/'1.0'/'bin').mkpath
    (Rack.factory('spam').path/'1.1'/'bin').mkpath
    (Rack.factory('spam').path/'1.1.1'/'bin').mkpath
    (Rack.factory('ham').path/'3-alpha'/'bin').mkpath
    (Rack.factory('ham').path/'4'/'bin').mkpath
    (Rack.factory('ham').path/'5').mkpath  # this '5' is no valid keg
    (Rack.factory('eggs').path/'0.0'/'bin').mkpath
    (Rack.factory('foo').path/'9.9.9.9.9.9.9'/'bin').mkpath
    (Rack.factory('foo').path/'HEAD'/'bin').mkpath
    (Rack.factory('empty').path).mkpath  # empty has only one dir, not a valid keg , so the rack is not real
    FileUtils.touch HOMEBREW_CELLAR/'afile'
  @diy = (HOMEBREW_PREFIX/'diytest')
  (@diy/'1.2'/'lib').mkpath
  FileUtils.ln_s @diy, HOMEBREW_CELLAR/'diytest'

  @all_that_should_be_real = ['testball', 'spam', 'ham', 'eggs', 'foo', 'diytest']

    FileUtils.mkpath HOMEBREW_PREFIX/"bin"
  end


  def test_no_file_as_rack
    r = Rack.new(HOMEBREW_CELLAR/'afile')
    assert r.valid?
    assert_raise RuntimeError do
        r.real?
      end
  end

  def test_all_fnames
    assert_equal Rack.all_fnames.sort, @all_that_should_be_real.sort
  end

  def test_all
    Rack.all.each{ |r| assert r.real? }
    Rack.all.each{ |r| assert @all_that_should_be_real.include? r.fname }
  end

  def test_factory
    @all_that_should_be_real.each { |n| Rack.factory(n).real?}
    assert_raise RuntimeError do
      Rack.factory('empty').real?
    end
    assert_raise RuntimeError do
      Rack.factory('fantasy').real?
    end
  end

  def teardown
    @diy.rmtree
    @formula.prefix.rmtree if @formula.prefix.exist?

    # Let's have this last safty net
    if HOMEBREW_CELLAR.to_s.start_with? '/usr' or HOMEBREW_PREFIX.to_s.start_with? '/usr'
      raise "Now that was close! I am not going to delete anything in /usr"
    else
       HOMEBREW_CELLAR.rmtree
      (HOMEBREW_PREFIX/"bin").rmtree
    end
  end
end
