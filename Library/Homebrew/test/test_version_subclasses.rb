require 'testing_env'
require 'version'
require 'os/mac/version'
require 'hardware'

class MacOSVersionTests < Test::Unit::TestCase
  def setup
    @v = MacOS::Version.new(10.7)
  end

  def test_compare_with_symbol
    assert_operator @v, :>, :snow_leopard
    assert_operator @v, :==, :lion
    assert_operator @v, :===, :lion
    assert_operator @v, :<, :mountain_lion
  end

  def test_compare_with_fixnum
    assert_operator @v, :>, 10
    assert_operator @v, :<, 11
  end

  def test_compare_with_float
    assert_operator @v, :>, 10.6
    assert_operator @v, :==, 10.7
    assert_operator @v, :===, 10.7
    assert_operator @v, :<, 10.8
  end

  def test_compare_with_string
    assert_operator @v, :>, "10.6"
    assert_operator @v, :==, "10.7"
    assert_operator @v, :===, "10.7"
    assert_operator @v, :<, "10.8"
  end

  def test_compare_with_version
    assert_operator @v, :>, Version.new(10.6)
    assert_operator @v, :==, Version.new(10.7)
    assert_operator @v, :===, Version.new(10.7)
    assert_operator @v, :<, Version.new(10.8)
  end

  def test_cat_tiger
    MacOS.stubs(:version).returns(MacOS::Version.new(10.4))
    Hardware::CPU.stubs(:type).returns(:ppc)
    Hardware::CPU.stubs(:family).returns(:foo)
    assert_equal :foo, MacOS.uncached_cat
  end

  def test_cat_leopard
    MacOS.stubs(:version).returns(MacOS::Version.new(10.5))
    assert_equal :leopard, MacOS.uncached_cat
  end

  def test_cat_snow_leopard_32
    MacOS.stubs(:version).returns(MacOS::Version.new(10.6))
    Hardware.stubs(:is_64_bit?).returns(false)
    assert_equal :snow_leopard_32, MacOS.uncached_cat
  end

  def test_cat_snow_leopard_64
    MacOS.stubs(:version).returns(MacOS::Version.new(10.6))
    Hardware.stubs(:is_64_bit?).returns(true)
    assert_equal :snow_leopard, MacOS.uncached_cat
  end

  def test_cat_lion
    MacOS.stubs(:version).returns(MacOS::Version.new(10.7))
    assert_equal :lion, MacOS.uncached_cat
  end

  def test_cat_mountain_lion
    MacOS.stubs(:version).returns(MacOS::Version.new(10.8))
    assert_equal :mountain_lion, MacOS.uncached_cat
  end
end
