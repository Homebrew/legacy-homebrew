require 'testing_env'

module ExtendArgvPlusYeast
  def reset
    @named = nil
    @downcased_unique_named = nil
    @formulae = nil
    @kegs = nil
    ARGV.shift while ARGV.length > 0
  end
end
ARGV.extend ExtendArgvPlusYeast


class ARGVTests < Test::Unit::TestCase

  def teardown
    ARGV.reset
  end

  def test_ARGV
    assert ARGV.named.empty?

    (HOMEBREW_CELLAR+'mxcl/10.0').mkpath

    ARGV.reset
    ARGV.unshift 'mxcl'
    assert_equal 1, ARGV.named.length
    assert_equal 1, ARGV.kegs.length
    assert_raises(FormulaUnavailableError) { ARGV.formulae }
  end

  def test_switch?
    ARGV.unshift "-ns"
    ARGV.unshift "-i"
    ARGV.unshift "--bar"
    assert ARGV.switch?('n')
    assert ARGV.switch?('s')
    assert ARGV.switch?('i')
    assert !ARGV.switch?('b')
    assert !ARGV.switch?('ns')
    assert !ARGV.switch?('bar')
    assert !ARGV.switch?('--bar')
    assert !ARGV.switch?('-n')
  end

  def test_filter_for_dependencies_clears_flags
    ARGV.unshift("--debug")
    ARGV.filter_for_dependencies do
      assert ARGV.empty?
    end
  end

  def test_filter_for_dependencies_ensures_argv_restored
    ARGV.expects(:replace).with(ARGV.clone)
    begin
      ARGV.filter_for_dependencies { raise Exception }
    rescue Exception
    end
  end

  def test_filter_for_dependencies_returns_block_value
    assert_equal 1, ARGV.filter_for_dependencies { 1 }
  end
end
