module ArchitectureListExtension
  # @private
  def fat?
    length > 1
  end

  # @private
  def intel_universal?
    intersects_all?(Hardware::CPU::INTEL_32BIT_ARCHS, Hardware::CPU::INTEL_64BIT_ARCHS)
  end

  # @private
  def ppc_universal?
    intersects_all?(Hardware::CPU::PPC_32BIT_ARCHS, Hardware::CPU::PPC_64BIT_ARCHS)
  end

  # Old-style 32-bit PPC/Intel universal, e.g. ppc7400 and i386
  # @private
  def cross_universal?
    intersects_all?(Hardware::CPU::PPC_32BIT_ARCHS, Hardware::CPU::INTEL_32BIT_ARCHS)
  end

  # @private
  def universal?
    intel_universal? || ppc_universal? || cross_universal?
  end

  def ppc?
    (Hardware::CPU::PPC_32BIT_ARCHS+Hardware::CPU::PPC_64BIT_ARCHS).any? { |a| self.include? a }
  end

  # @private
  def remove_ppc!
    (Hardware::CPU::PPC_32BIT_ARCHS+Hardware::CPU::PPC_64BIT_ARCHS).each { |a| delete a }
  end

  def as_arch_flags
    collect { |a| "-arch #{a}" }.join(" ")
  end

  def as_cmake_arch_flags
    join(";")
  end

  protected

  def intersects_all?(*set)
    set.all? do |archset|
      archset.any? { |a| self.include? a }
    end
  end
end
