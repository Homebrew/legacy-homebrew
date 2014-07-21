require 'testing_env'
require 'extend/ARGV'

class ArgvExtensionTests < Homebrew::TestCase
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
    keg.parent.rmtree
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

  def test_flag?
    @argv << "--foo" << "-bq" << "--bar"
    assert @argv.flag?("--foo")
    assert @argv.flag?("--bar")
    assert @argv.flag?("--baz")
    assert @argv.flag?("--qux")
    assert !@argv.flag?("--frotz")
    assert !@argv.flag?("--debug")
  end
end
