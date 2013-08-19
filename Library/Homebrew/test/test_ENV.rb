require 'testing_env'
require 'extend/ENV'

class EnvironmentTests < Test::Unit::TestCase
  def setup
    @env = {}.extend(EnvActivation)
    @env.activate_extensions!
  end

  def test_ENV_options
    @env.gcc_4_0
    @env.O3
    @env.minimal_optimization
    @env.no_optimization
    @env.libxml2
    @env.enable_warnings
    assert !@env.cc.empty?
    assert !@env.cxx.empty?
  end

  def test_switching_compilers
    @env.llvm
    @env.clang
    assert_nil @env['LD']
    assert_equal @env['OBJC'], @env['CC']
  end

  def test_with_build_environment_restores_env
    before = @env.dup
    @env.with_build_environment do
      @env['foo'] = 'bar'
    end
    assert_nil @env['foo']
    assert_equal before, @env
  end

  def test_with_build_environment_ensures_env_restored
    before = @env.dup
    begin
      @env.with_build_environment do
        @env['foo'] = 'bar'
        raise Exception
      end
    rescue Exception
    end
    assert_nil @env['foo']
    assert_equal before, @env
  end

  def test_with_build_environment_returns_block_value
    assert_equal 1, @env.with_build_environment { 1 }
  end

  def test_with_build_environment_does_not_mutate_interface
    expected = @env.methods
    @env.with_build_environment { assert_equal expected, @env.methods }
    assert_equal expected, @env.methods
  end

  def test_append_path
    @env.append_path 'FOO', '/usr/bin'
    assert_equal '/usr/bin', @env['FOO']
    @env.append_path 'FOO', '/bin'
    assert_equal "/usr/bin#{File::PATH_SEPARATOR}/bin", @env['FOO']
  end

  def test_prepend_path
    @env.prepend_path 'FOO', '/usr/bin'
    assert_equal '/usr/bin', @env['FOO']
    @env.prepend_path 'FOO', '/bin'
    assert_equal "/bin#{File::PATH_SEPARATOR}/usr/bin", @env['FOO']
  end
end
