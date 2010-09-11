require 'testing_env'
require 'utils'
require 'extend/ENV'
ENV.extend(HomebrewEnvExtension)
  
class EnvironmentTests < Test::Unit::TestCase
  def test_ENV_options
    ENV.gcc_4_0
    ENV.gcc_4_2
    ENV.O3
    ENV.minimal_optimization
    ENV.no_optimization
    ENV.libxml2
    ENV.x11
    ENV.enable_warnings
    assert !ENV.cc.empty?
    assert !ENV.cxx.empty?
  end
end
