require 'testing_env'
require 'extend/object'

class InstanceExecTests < Test::Unit::TestCase
  def test_evaluates_in_context_of_receiver
    assert_equal 1, [1].instance_exec { first }
  end

  def test_passes_arguments_to_block
    assert_equal 2, [1].instance_exec(1) { |x| first + x }
  end

  def test_does_not_persist_temporary_singleton_method
    obj = Object.new
    before = obj.methods
    obj.instance_exec { methods }
    after = obj.methods
    assert_equal before, after
  end
end
