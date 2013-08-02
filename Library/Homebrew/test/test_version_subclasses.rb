require 'testing_env'
require 'version'
require 'os/mac/version'

class MacOSVersionTests < Test::Unit::TestCase
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
end
