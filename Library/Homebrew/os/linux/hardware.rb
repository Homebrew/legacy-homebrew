module LinuxCPUs
  OPTIMIZATION_FLAGS = {}.freeze
  def optimization_flags; OPTIMIZATION_FLAGS; end

  # Linux supports x86 only, and universal archs do not apply
  def arch_32_bit; :i386; end
  def arch_64_bit; :x86_64; end
  def universal_archs; []; end

  def type
    @cpu_type ||= case `uname -m`
      when /i[3-6]86/, /x86_64/
        :intel
      else
        :dunno
      end
  end

  def family
    :dunno
  end
  alias_method :intel_family, :family

  def cores
    `grep -c ^processor /proc/cpuinfo`.to_i
  end

  def bits
    is_64_bit? ? 64 : 32
  end

  def is_64_bit?
    return @is_64_bit if defined? @is_64_bit
    @is_64_bit = /64/ === `uname -m`
  end
end
