class Hardware
  class << self
    # We won't change the name because of backward compatibility.
    # So disable rubocop here.
    def is_32_bit? # rubocop:disable Style/PredicateName
      !CPU.is_64_bit?
    end

    # We won't change the name because of backward compatibility.
    # So disable rubocop here.
    def is_64_bit? # rubocop:disable Style/PredicateName
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
