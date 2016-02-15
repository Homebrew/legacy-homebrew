module MachO
  # @param value [Fixnum] the number being rounded
  # @param round [Fixnum] the number being rounded with
  # @return [Fixnum] the next number >= `value` such that `round` is its divisor
  # @see http://www.opensource.apple.com/source/cctools/cctools-870/libstuff/rnd.c
  def self.round(value, round)
    round -= 1
    value += round
    value &= ~round
    value
  end

  # @param num [Fixnum] the number being checked
  # @return [Boolean] true if `num` is a valid Mach-O magic number, false otherwise
  def self.magic?(num)
    MH_MAGICS.has_key?(num)
  end

  # @param num [Fixnum] the number being checked
  # @return [Boolean] true if `num` is a valid Fat magic number, false otherwise
  def self.fat_magic?(num)
    num == FAT_MAGIC || num == FAT_CIGAM
  end

  # @param num [Fixnum] the number being checked
  # @return [Boolean] true if `num` is a valid 32-bit magic number, false otherwise
  def self.magic32?(num)
    num == MH_MAGIC || num == MH_CIGAM
  end

  # @param num [Fixnum] the number being checked
  # @return [Boolean] true if `num` is a valid 64-bit magic number, false otherwise
  def self.magic64?(num)
    num == MH_MAGIC_64 || num == MH_CIGAM_64
  end
end
