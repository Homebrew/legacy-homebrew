require 'testing_env'

require 'extend/ARGV' # needs to be after test/unit to avoid conflict with OptionsParser
ARGV.extend(HomebrewArgvExtension)

require 'hardware'


class HardwareTests < Test::Unit::TestCase
  # these will raise if we don't recognise your mac, but that prolly 
  # indicates something went wrong rather than we don't know
  def test_hardware_cpu_type
    assert [:intel, :ppc].include?(Hardware.cpu_type)
  end
  
  def test_hardware_intel_family
    if Hardware.cpu_type == :intel
      assert [:core, :core2, :penryn, :nehalem, :arrandale, :sandybridge].include?(Hardware.intel_family)
    end
  end
end
