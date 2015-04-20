class Hardware
  class << self
    def is_32_bit?
      not CPU.is_64_bit?
    end

    def is_64_bit?
      CPU.is_64_bit?
    end

    def bits
      Hardware::CPU.bits
    end

    def cpu_type
      Hardware::CPU.type
    end

    def cpu_family
      Hardware::CPU.family
    end
    alias_method :intel_family, :cpu_family
    alias_method :ppc_family, :cpu_family

    def processor_count
      Hardware::CPU.cores
    end
  end
end
