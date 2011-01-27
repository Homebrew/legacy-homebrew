class Hardware
  # These methods use info spewed out by sysctl.
  # Look in <mach/machine.h> for decoding info.

  def self.cpu_type
    @@cpu_type ||= self.sysctl_int('hw.cputype')

    case @@cpu_type
    when 7
      :intel
    when 18
      :ppc
    else
      :dunno
    end
  end
  
  def self.ppc_family
    # Note: This list is defined in: /usr/include/mach/machine.h
    types = ['POWERPC_ALL',
      'POWERPC_601',
      'POWERPC_602',
      'POWERPC_603',
      'POWERPC_603e',
      'POWERPC_603ev',
      'POWERPC_604',
      'POWERPC_604e',
      'POWERPC_620',
      'POWERPC_750',
      'POWERPC_7400',
      'POWERPC_7450']
    type100 = 'POWERPC_970'
    
    @@ppc_family ||= self.sysctl_int('hw.cpusubtype')
    if @@ppc_family == 100
      type100.downcase.to_sym
    elsif @@ppc_family <= 0 or @@ppc_family > types.length
      :dunno
    else
      types[@@ppc_family].downcase.to_sym
    end
  end

  def self.intel_family
    @@intel_family ||=  self.sysctl_int('hw.cpufamily')

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
    else
      :dunno
    end
  end
  
  def self.any_family
    case self.cpu_type
    when :intel
      Hardware.intel_family
    when :ppc
      Hardware.ppc_family
    else
      :dunno
    end
  end

  def self.processor_count
    @@processor_count ||= self.sysctl_int('hw.ncpu')
  end
  
  def self.cores_as_words
    case Hardware.processor_count
    when 1 then 'single'
    when 2 then 'dual'
    when 4 then 'quad'
    else
      Hardware.processor_count
    end
  end

  def self.is_32_bit?
    not self.is_64_bit?
  end

  def self.is_64_bit?
    self.sysctl_bool("hw.cpu64bit_capable")
  end
  
  def self.bits
    Hardware.is_64_bit? ? 64 : 32
  end

protected
  def self.sysctl_int(property)
    result = nil
    IO.popen("/usr/sbin/sysctl -n #{property} 2>/dev/null") do |f|
      result = f.gets.to_i
    end
    return result
  end

  def self.sysctl_bool(property)
    result = nil
    IO.popen("/usr/sbin/sysctl -n #{property} 2>/dev/null") do |f|
      result = f.gets.to_i # should be 0 or 1
    end
    $?.success? && result == 1 # sysctl call succeded and printed 1
  end
end

def snow_leopard_64?
  MACOS_VERSION >= 10.6 and Hardware.is_64_bit?
end
