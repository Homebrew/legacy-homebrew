require 'testing_env'
require 'debrew/raise_plus'

class RaisePlusTests < Test::Unit::TestCase
  include RaisePlus

  def test_raises_runtime_error_when_no_args
    assert_raises(RuntimeError) { raise }
  end

  def test_raises_runtime_error_with_string_arg
    raise "foo"
  rescue Exception => e
    assert_kind_of RuntimeError, e
    assert_equal "foo", e.to_s
  end

  def test_raises_given_exception_with_new_to_s
    a = Exception.new("foo")
    raise a, "bar"
  rescue Exception => e
    assert_equal "bar", e.to_s
  end

  def test_raises_same_instance
    a = Exception.new("foo")
    raise a
  rescue Exception => e
    assert_same e, a
  end

  def test_raises_exception_class
    assert_raises(StandardError) { raise StandardError }
  end

  def test_raises_type_error_for_bad_args
    assert_raises(TypeError) { raise 1 }
  end

  def test_raise_is_private
    assert_raises(NoMethodError) do
      Object.new.extend(RaisePlus).raise(RuntimeError)
    end
  end
end
