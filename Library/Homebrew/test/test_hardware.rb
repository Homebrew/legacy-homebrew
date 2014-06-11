require 'testing_env'
require 'hardware'

class HardwareTests < Homebrew::TestCase
  def test_hardware_cpu_type
    assert [:intel, :ppc].include?(Hardware::CPU.type)
  end

  def test_hardware_intel_family
    families = [:core, :core2, :penryn, :nehalem, :arrandale, :sandybridge, :ivybridge, :haswell]
    assert families.include?(Hardware::CPU.family)
  end if Hardware::CPU.intel?
end
