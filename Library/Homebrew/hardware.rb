class Hardware
  case RUBY_PLATFORM.downcase
  when /darwin/
    require 'os/mac/hardware'
    extend MacOSHardware
  when /linux/
    require 'os/linux/hardware'
    extend LinuxHardware
  else
    raise "The system `#{`uname`.chomp}' is not supported."
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

  def self.bits
    Hardware.is_64_bit? ? 64 : 32
  end
end
