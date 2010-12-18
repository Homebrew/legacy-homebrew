require 'testing_env'

require 'extend/ARGV' # needs to be after test/unit to avoid conflict with OptionsParser
ARGV.extend(HomebrewArgvExtension)


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

  def test_ARGV
    assert_raises(FormulaUnspecifiedError) { ARGV.formulae }
    assert_raises(KegUnspecifiedError) { ARGV.kegs }
    assert ARGV.named.empty?
    
    (HOMEBREW_CELLAR+'mxcl/10.0').mkpath
    
    ARGV.reset
    ARGV.unshift 'mxcl'
    assert_equal 1, ARGV.named.length
    assert_equal 1, ARGV.kegs.length
    assert_raises(FormulaUnavailableError) { ARGV.formulae }
  end
  
end
