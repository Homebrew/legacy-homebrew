require 'testing_env'
require 'build_environment'

class BuildEnvironmentTests < Homebrew::TestCase
  def setup
    @env = BuildEnvironment.new
  end

  def test_shovel_returns_self
    assert_same @env, (@env << :foo)
  end

  def test_std?
    @env << :std
    assert_predicate @env, :std?
  end

  def test_userpaths?
    @env << :userpaths
    assert_predicate @env, :userpaths?
  end

  def test_modify_build_environment
    @env << Proc.new { raise StandardError }
    assert_raises(StandardError) do
      @env.modify_build_environment(self)
    end
  end

  def test_marshal
    @env << :userpaths
    @env << Proc.new { 1 }
    dump = Marshal.dump(@env)
    assert_predicate Marshal.load(dump), :userpaths?
  end

  def test_env_block
    foo = mock("foo")
    @env << Proc.new { foo.some_message }
    foo.expects(:some_message)
    @env.modify_build_environment(self)
  end

  def test_env_block_with_argument
    foo = mock("foo")
    @env << Proc.new { |x| x.some_message }
    foo.expects(:some_message)
    @env.modify_build_environment(foo)
  end
end

class BuildEnvironmentDSLTests < Homebrew::TestCase
  def make_instance(&block)
    Class.new do
      extend BuildEnvironmentDSL
      def env; self.class.env end
      class_eval(&block)
    end.new
  end

  def test_env_single_argument
    obj = make_instance { env :userpaths }
    assert_predicate obj.env, :userpaths?
  end

  def test_env_multiple_arguments
    obj = make_instance { env :userpaths, :std }
    assert_predicate obj.env, :userpaths?
    assert_predicate obj.env, :std?
  end
end
