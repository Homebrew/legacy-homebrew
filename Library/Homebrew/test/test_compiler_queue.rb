require 'testing_env'
require 'compilers'

class CompilerQueueTests < Test::Unit::TestCase
  FakeCompiler = Struct.new(:name, :priority)

  def setup
    @q = CompilerQueue.new
  end

  def test_shovel_returns_self
    assert_same @q, (@q << Object.new)
  end

  def test_empty
    assert @q.empty?
  end

  def test_queues_items
    a = FakeCompiler.new(:foo, 0)
    b = FakeCompiler.new(:bar, 0)
    @q << a << b
    assert_equal a, @q.pop
    assert_equal b, @q.pop
    assert_nil @q.pop
  end

  def test_pops_items_by_priority
    a = FakeCompiler.new(:foo, 0)
    b = FakeCompiler.new(:bar, 0.5)
    c = FakeCompiler.new(:baz, 1)
    @q << a << b << c
    assert_equal c, @q.pop
    assert_equal b, @q.pop
    assert_equal a, @q.pop
    assert_nil @q.pop
  end
end
