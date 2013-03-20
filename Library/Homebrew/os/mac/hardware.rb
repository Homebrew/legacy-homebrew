module MacOSHardware
  # These methods use info spewed out by sysctl.
  # Look in <mach/machine.h> for decoding info.
  def cpu_type
    @@cpu_type ||= `/usr/sbin/sysctl -n hw.cputype`.to_i

    case @@cpu_type
    when 7
      :intel
    when 18
      :ppc
    else
      :dunno
    end
  end

  def intel_family
    @@intel_family ||= `/usr/sbin/sysctl -n hw.cpufamily`.to_i

    case @@intel_family
    when 0x73d67300 # Yonah: Core Solo/Duo
      :core
    when 0x426f69ef # Merom: Core 2 Duo
      :core2
    when 0x78ea4fbc # Penryn
      :penryn
    when 0x6b5a4cd2 # Nehalem
      :nehalem
    when 0x573B5EEC # Arrandale
      :arrandale
    when 0x5490B78C # Sandy Bridge
      :sandybridge
    when 0x1F65E835 # Ivy Bridge
      :ivybridge
    else
      :dunno
    end
  end

  def processor_count
    @@processor_count ||= `/usr/sbin/sysctl -n hw.ncpu`.to_i
  end

  def is_64_bit?
    return @@is_64_bit if defined? @@is_64_bit
    @@is_64_bit = sysctl_bool("hw.cpu64bit_capable")
  end

protected
  def sysctl_bool(property)
    result = nil
    IO.popen("/usr/sbin/sysctl -n #{property} 2>/dev/null") do |f|
      result = f.gets.to_i # should be 0 or 1
    end
    $?.success? && result == 1 # sysctl call succeded and printed 1
  end
end
