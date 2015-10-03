require "testing_env"
require "version"
require "os/mac/version"

class MacOSVersionTests < Homebrew::TestCase
  def setup
    @v = MacOS::Version.new("10.7")
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
    assert_operator @v, :>, Version.new("10.6")
    assert_operator @v, :==, Version.new("10.7")
    assert_operator @v, :===, Version.new("10.7")
    assert_operator @v, :<, Version.new("10.8")
  end

  def test_from_symbol
    assert_equal @v, MacOS::Version.from_symbol(:lion)
    assert_raises(ArgumentError) { MacOS::Version.from_symbol(:foo) }
  end

  def test_pretty_name
    assert_equal "El Capitan", MacOS::Version.new("10.11").pretty_name
    assert_equal "Mountain Lion", MacOS::Version.new("10.8").pretty_name
    assert_equal "Yosemite", MacOS::Version.new("10.10").pretty_name
  end
end
