require 'testing_env'
require 'utils'
require 'hardware'
require 'extend/ENV'
require 'extend/ARGV'
ENV.extend(HomebrewEnvExtension)
ARGV.extend(HomebrewArgvExtension)
  
class EnvironmentTests < Test::Unit::TestCase
  def test_ENV_options
    ENV.gcc_4_0
    begin
      ENV.gcc_4_2
    rescue RuntimeError => e
      if `sw_vers -productVersion` =~ /10\.(\d+)/ and $1.to_i < 7
        raise e
      end
    end
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
