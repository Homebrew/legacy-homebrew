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
end
