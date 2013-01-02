require 'testing_env'
require 'test/testball'

# We temporarily redefine bottles_supported? because the
# following tests assume it is true, but other tests may
# expect the real value.
module MacOS extend self
  def bottles_are_supported
    alias :old_bottles_supported? :bottles_supported?
    def bottles_supported?; true end
    yield
    def bottles_supported?; old_bottles_supported? end
  end
end

class BottleTests < Test::Unit::TestCase
  def test_bottle_spec_selection
    MacOS.bottles_are_supported do
      f = SnowLeopardBottleSpecTestBall.new

      assert_equal case MacOS.cat
        when :snowleopard then f.bottle
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
end
