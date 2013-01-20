require 'testing_env'
require 'build_environment'

class BuildEnvironmentTests < Test::Unit::TestCase
  def setup
    @env = BuildEnvironment.new
  end

  def test_shovel_returns_self
    assert_same @env, (@env << :foo)
  end

  def test_std?
    @env << :std
    assert @env.std?
  end

  def test_userpaths?
    @env << :userpaths
    assert @env.userpaths?
  end

  def test_modify_build_environment
    @env << Proc.new { 1 }
    assert_equal 1, @env.modify_build_environment
  end

  def test_marshal
    @env << :userpaths
    @env << Proc.new { 1 }
    dump = Marshal.dump(@env)
    assert Marshal.load(dump).userpaths?
  end
end

class BuildEnvironmentDSLTests < Test::Unit::TestCase
  def make_instance(&block)
    Class.new do
      extend BuildEnvironmentDSL
      def env; self.class.env end
      class_eval(&block)
    end.new
  end

  def test_env_single_argument
    obj = make_instance { env :userpaths }
    assert obj.env.userpaths?
  end

  def test_env_multiple_arguments
    obj = make_instance { env :userpaths, :std }
    assert obj.env.userpaths?
    assert obj.env.std?
  end
end
