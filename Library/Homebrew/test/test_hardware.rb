require 'testing_env'
require 'hardware'

class HardwareTests < Test::Unit::TestCase
  # these will raise if we don't recognise your mac, but that prolly 
  # indicates something went wrong rather than we don't know
  def test_hardware_cpu_type
    assert [:intel, :ppc].include?(Hardware::CPU.type)
  end

  def test_hardware_intel_family
    if Hardware::CPU.type == :intel
      assert [:core, :core2, :penryn, :nehalem,
        :arrandale, :sandybridge, :ivybridge, :haswell].include?(Hardware::CPU.family)
    end
  end
end
