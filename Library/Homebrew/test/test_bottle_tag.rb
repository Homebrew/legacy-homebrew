require 'testing_env'
require 'bottles'

class BottleTagTests < Test::Unit::TestCase
  def test_cat_tiger_ppc
    MacOS.stubs(:version).returns(MacOS::Version.new(10.4))
    Hardware::CPU.stubs(:type).returns(:ppc)
    Hardware::CPU.stubs(:family).returns(:foo)
    assert_equal :foo, bottle_tag
  end

  def test_cat_tiger_intel
    MacOS.stubs(:version).returns(MacOS::Version.new(10.4))
    Hardware::CPU.stubs(:type).returns(:intel)
    assert_equal :tiger, bottle_tag
  end

  def test_cat_leopard
    MacOS.stubs(:version).returns(MacOS::Version.new(10.5))
    assert_equal :leopard, bottle_tag
  end

  def test_cat_snow_leopard_32
    MacOS.stubs(:version).returns(MacOS::Version.new(10.6))
    Hardware.stubs(:is_64_bit?).returns(false)
    assert_equal :snow_leopard_32, bottle_tag
  end

  def test_cat_snow_leopard_64
    MacOS.stubs(:version).returns(MacOS::Version.new(10.6))
    Hardware.stubs(:is_64_bit?).returns(true)
    assert_equal :snow_leopard, bottle_tag
  end

  def test_cat_lion
    MacOS.stubs(:version).returns(MacOS::Version.new(10.7))
    assert_equal :lion, bottle_tag
  end

  def test_cat_mountain_lion
    MacOS.stubs(:version).returns(MacOS::Version.new(10.8))
    assert_equal :mountain_lion, bottle_tag
  end
end
