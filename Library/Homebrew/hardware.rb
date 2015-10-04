require "os"

class Hardware
  module CPU
    extend self
    INTEL_32BIT_ARCHS = [:i386].freeze
    INTEL_64BIT_ARCHS = [:x86_64].freeze
    PPC_32BIT_ARCHS   = [:ppc, :ppc7400, :ppc7450, :ppc970].freeze
    PPC_64BIT_ARCHS   = [:ppc64].freeze

    def type
      :dunno
    end

    def family
      :dunno
    end

    def cores
      1
    end

    def bits
      64
    end

    def is_32_bit?
      bits == 32
    end

    def is_64_bit?
      bits == 64
    end

    def intel?
      type == :intel
    end

    def ppc?
      type == :ppc
    end

    def features
      []
    end

    def feature?(name)
      features.include?(name)
    end
  end

  if OS.mac?
    require "os/mac/hardware"
    CPU.extend MacCPUs
  elsif OS.linux?
    require "os/linux/hardware"
    CPU.extend LinuxCPUs
  else
    raise "The system `#{`uname`.chomp}' is not supported."
  end

  def self.cores_as_words
    case Hardware::CPU.cores
    when 1 then "single"
    when 2 then "dual"
    when 4 then "quad"
    else
      Hardware::CPU.cores
    end
  end

  def self.oldest_cpu
    if Hardware::CPU.intel?
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
