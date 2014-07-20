require 'testing_env'
require 'build_environment'

class BuildEnvironmentTests < Homebrew::TestCase
  def setup
    @env = BuildEnvironment.new
  end

  def test_shovel_returns_self
    assert_same @env, (@env << :foo)
  end

  def test_merge_returns_self
    assert_same @env, @env.merge([])
  end

  def test_std?
    @env << :std
    assert_predicate @env, :std?
  end

  def test_userpaths?
    @env << :userpaths
    assert_predicate @env, :userpaths?
  end
end

class BuildEnvironmentDSLTests < Homebrew::TestCase
  def make_instance(&block)
    obj = Object.new.extend(BuildEnvironmentDSL)
    obj.instance_eval(&block)
    obj
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
