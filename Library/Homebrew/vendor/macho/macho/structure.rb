module MachO
  # A general purpose pseudo-structure.
  # @abstract
  class MachOStructure
    # The format of the data structure, in String#unpack format.
    FORMAT = ""

    # The size of the data structure, in bytes.
    SIZEOF = 0

    # @return [Fixnum] the size, in bytes, of the represented structure.
    def self.bytesize
      self::SIZEOF
    end

    # @return [MachO::MachOStructure] a new MachOStructure initialized with `bin`
    # @api private
    def self.new_from_bin(bin)
      self.new(*bin.unpack(self::FORMAT))
    end
  end
end
