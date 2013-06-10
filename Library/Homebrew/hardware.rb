class Hardware
  module CPU extend self
    def type
      @type || :dunno
    end

    def family
      @family || :dunno
    end

    def cores
      @cores || 1
    end

    def bits
      @bits || 64
    end

    def is_32_bit?
      bits == 32
    end

    def is_64_bit?
      bits == 64
    end
  end

  case RUBY_PLATFORM.downcase
  when /darwin/
    require 'os/mac/hardware'
    CPU.extend MacCPUs
  when /linux/
    require 'os/linux/hardware'
    CPU.extend LinuxCPUs
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

  def self.oldest_cpu
    if Hardware::CPU.type == :intel
      if Hardware::CPU.is_64_bit?
        :core2
      else
        :core
      end
    else
      Hardware::CPU.family
    end
  end
end
