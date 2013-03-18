module LinuxHardware
  def cpu_type
    @@cpu_type ||= case `uname -m`
      when /x86_64/
        :intel
      when /i386/
        :intel
      else
        :dunno
      end
  end

  def intel_family
    :dunno
  end

  def processor_count
    `grep -c ^processor /proc/cpuinfo`.to_i
  end

  def is_64_bit?
    return @@is_64_bit if defined? @@is_64_bit
    @@is_64_bit = /64/ === `uname -m`
  end
end
