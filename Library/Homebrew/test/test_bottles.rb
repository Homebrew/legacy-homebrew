require 'testing_env'
require 'test/testball'

class BottleTests < Test::Unit::TestCase
  def test_bottle_spec_selection
    f = SnowLeopardBottleSpecTestBall.new

    assert_equal case MacOS.cat
      when :snow_leopard then f.bottle
      else f.stable
      end, f.active_spec

    f = LionBottleSpecTestBall.new
    assert_equal case MacOS.cat
      when :lion then f.bottle
      else f.stable
      end, f.active_spec

    f = AllCatsBottleSpecTestBall.new
    assert_equal f.bottle, f.active_spec
  end
end
