module LinuxCPUs
  OPTIMIZATION_FLAGS = {
    :penryn => "-march=core2 -msse4.1",
    :core2 => "-march=core2",
    :core => "-march=prescott"
  }.freeze
  def optimization_flags
    OPTIMIZATION_FLAGS
  end

  # Linux supports x86 only, and universal archs do not apply
  def arch_32_bit
    :i386
  end

  def arch_64_bit
    :x86_64
  end

  def universal_archs
    [].extend ArchitectureListExtension
  end

  def cpuinfo
    @cpuinfo ||= File.read("/proc/cpuinfo")
  end

  def type
    @type ||= if cpuinfo =~ /Intel|AMD/
      :intel
    else
      :dunno
    end
  end

  def family
    cpuinfo[/^cpu family\s*: ([0-9]+)/, 1].to_i
  end
  alias_method :intel_family, :family

  def cores
    cpuinfo.scan(/^processor/).size
  end

  def flags
    @flags ||= cpuinfo[/^flags.*/, 0].split
  end

  # Compatibility with Mac method, which returns lowercase symbols
  # instead of strings
  def features
    @features ||= flags[1..-1].map(&:intern)
  end

  %w[aes altivec avx avx2 lm sse3 ssse3 sse4 sse4_2].each do |flag|
    define_method(flag + "?") { flags.include? flag }
  end
  alias_method :is_64_bit?, :lm?

  def bits
    is_64_bit? ? 64 : 32
  end
end
