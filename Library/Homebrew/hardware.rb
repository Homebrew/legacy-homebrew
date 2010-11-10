class Hardware
  # These methods use info spewed out by sysctl.
  # Look in <mach/machine.h> for decoding info.

  def self.cpu_type
    arch = SystemCommand.arch
    if arch =~ /i386|x86_64|i686/
      return :intel
    elsif arch =~ /ppc|powerpc/
      return :ppc
    else
      return :dunno
    end
  end

  def self.intel_family
    if RUBY_PLATFORM =~ /.*-linux/
      return :dunno
    elsif RUBY_PLATFORM =~ /.*darwin.*/
      intel_family ||= `#{SystemCommand.sysctl} -n hw.cpufamily`.to_i
      fam = :dunno
      case intel_family
      when 0x73d67300 # Yonah: Core Solo/Duo
        fam = :core
      when 0x426f69ef # Merom: Core 2 Duo
        fam = :core2
      when 0x78ea4fbc # Penryn
        fam = :penryn
      when 0x6b5a4cd2 # Nehalem
        fam = :nehalem
      when 0x573B5EEC # Arrandale
        fam = :arrandale
      else
        fam = :dunno
      end
      return fam
    else
      return :dunno
    end
  end

  def self.processor_count
    if RUBY_PLATFORM =~ /.*-linux/
      `#{SystemCommand.cat} /proc/cpuinfo|grep processor|wc -l`.to_i
    elsif RUBY_PLATFORM =~ /.*darwin.*/
      `#{SystemCommand.sysctl} -n hw.ncpu`.to_i
    else
      1
    end
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
  def self.sysctl_bool(property)
    result = nil
    IO.popen("#{SystemCommand.sysctl} -n #{property} 2>/dev/null") do |f|
      result = f.gets.to_i # should be 0 or 1
    end
    $?.success? && result == 1 # sysctl call succeded and printed 1
  end
end

def snow_leopard_64?
  MACOS_VERSION >= 10.6 and Hardware.is_64_bit?
end
