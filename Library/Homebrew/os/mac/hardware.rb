module MacCPUs
  OPTIMIZATION_FLAGS = {
    :penryn => '-march=core2 -msse4.1',
    :core2 => '-march=core2',
    :core => '-march=prescott',
    :g3 => '-mcpu=750',
    :g4 => '-mcpu=7400',
    :g4e => '-mcpu=7450',
    :g5 => '-mcpu=970'
  }.freeze
  def optimization_flags; OPTIMIZATION_FLAGS; end

  # These methods use info spewed out by sysctl.
  # Look in <mach/machine.h> for decoding info.
  def type
    @type ||= `/usr/sbin/sysctl -n hw.cputype`.to_i
    case @type
    when 7
      :intel
    when 18
      :ppc
    else
      :dunno
    end
  end

  def family
    if type == :intel
      @intel_family ||= `/usr/sbin/sysctl -n hw.cpufamily`.to_i
      case @intel_family
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
      when 0x10B282DC # Haswell
        :haswell
      else
        :dunno
      end
    elsif type == :ppc
      @ppc_family ||= `/usr/sbin/sysctl -n hw.cpusubtype`.to_i
      case @ppc_family
      when 9
        :g3  # PowerPC 750
      when 10
        :g4  # PowerPC 7400
      when 11
        :g4e # PowerPC 7450
      when 100
        :g5  # PowerPC 970
      else
        :dunno
      end
    end
  end

  def cores
    @cores ||= `/usr/sbin/sysctl -n hw.ncpu`.to_i
  end

  def bits
    return @bits if defined? @bits

    is_64_bit = sysctl_bool("hw.cpu64bit_capable")
    @bits ||= is_64_bit ? 64 : 32
  end

  def altivec?
    @altivec ||= sysctl_bool('hw.optional.altivec')
  end

  def avx?
    @avx ||= sysctl_bool('hw.optional.avx1_0')
  end

  def sse3?
    @sse3 ||= sysctl_bool('hw.optional.sse3')
  end

  def sse4?
    @sse4 ||= sysctl_bool('hw.optional.sse4_1')
  end

  def sse4_2?
    @sse4 ||= sysctl_bool('hw.optional.sse4_2')
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
