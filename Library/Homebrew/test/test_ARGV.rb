require 'testing_env'
require 'extend/ARGV'

class ArgvExtensionTests < Test::Unit::TestCase
  def setup
    @argv = [].extend(HomebrewArgvExtension)
  end

  def test_argv_formulae
    @argv.unshift 'mxcl'
    assert_raises(FormulaUnavailableError) { @argv.formulae }
  end

  def test_argv_kegs
    keg = HOMEBREW_CELLAR + "mxcl/10.0"
    keg.mkpath
    @argv << 'mxcl'
    assert_equal 1, @argv.kegs.length
  ensure
    keg.rmtree
  end

  def test_argv_named
    @argv << 'mxcl' << '--debug' << '-v'
    assert_equal 1, @argv.named.length
  end

  def test_empty_argv
    assert_empty @argv.named
    assert_empty @argv.kegs
    assert_empty @argv.formulae
    assert_empty @argv
  end

  def test_switch?
    @argv << "-ns" << "-i" << "--bar"
    %w{n s i}.each { |s| assert @argv.switch?(s) }
    %w{b ns bar --bar -n}.each { |s| assert !@argv.switch?(s) }
  end

  def test_filter_for_dependencies_clears_flags
    @argv << "--debug"
    @argv.filter_for_dependencies { assert @argv.empty? }
  end

  def test_filter_for_dependencies_ensures_argv_restored
    @argv.expects(:replace).with(@argv.clone)
    begin
      @argv.filter_for_dependencies { raise Exception }
    rescue Exception
    end
  end

  def test_filter_for_dependencies_returns_block_value
    assert_equal 1, @argv.filter_for_dependencies { 1 }
  end
end
