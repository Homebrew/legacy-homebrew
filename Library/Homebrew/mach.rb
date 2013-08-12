module ArchitectureListExtension
  def fat?
    length > 1
  end

  def intel_universal?
    intersects_all?(Hardware::CPU::INTEL_32BIT_ARCHS, Hardware::CPU::INTEL_64BIT_ARCHS)
  end

  def ppc_universal?
    intersects_all?(Hardware::CPU::PPC_32BIT_ARCHS, Hardware::CPU::PPC_64BIT_ARCHS)
  end

  # Old-style 32-bit PPC/Intel universal, e.g. ppc7400 and i386
  def cross_universal?
    intersects_all?(Hardware::CPU::PPC_32BIT_ARCHS, Hardware::CPU::INTEL_32BIT_ARCHS)
  end

  def universal?
    intel_universal? || ppc_universal? || cross_universal?
  end

  def ppc?
    (PPC_32BIT_ARCHS+PPC_64BIT_ARCHS).any? {|a| self.include? a}
  end

  def remove_ppc!
    (Hardware::CPU::PPC_32BIT_ARCHS+Hardware::CPU::PPC_64BIT_ARCHS).each {|a| self.delete a}
  end

  def as_arch_flags
    self.collect{ |a| "-arch #{a}" }.join(' ')
  end

  def as_cmake_arch_flags
    self.join(';')
  end

  protected

  def intersects_all?(*set)
    set.all? do |archset|
      archset.any? {|a| self.include? a}
    end
  end
end

module MachO
  # Mach-O binary methods, see:
  # /usr/include/mach-o/loader.h
  # /usr/include/mach-o/fat.h

  def mach_data
    @mach_data ||= begin
      offsets = []
      mach_data = []

      header = read(8).unpack("N2")
      case header[0]
      when 0xcafebabe # universal
        header[1].times do |i|
          # header[1] is the number of struct fat_arch in the file.
          # Each struct fat_arch is 20 bytes, and the 'offset' member
          # begins 8 bytes into the struct, with an additional 8 byte
          # offset due to the struct fat_header at the beginning of
          # the file.
          offsets << read(4, 20*i + 16).unpack("N")[0]
        end
      when 0xcefaedfe, 0xcffaedfe, 0xfeedface, 0xfeedfacf # Single arch
        offsets << 0
      when 0x7f454c46 # ELF
        mach_data << { :arch => :x86_64, :type => :executable }
      else
        raise "Not a Mach-O binary."
      end

      offsets.each do |offset|
        arch = case read(8, offset).unpack("N2")
          when [0xcefaedfe, 0x07000000] then :i386
          when [0xcffaedfe, 0x07000001] then :x86_64
          when [0xfeedface, 0x00000012] then :ppc7400
          when [0xfeedfacf, 0x01000012] then :ppc64
          else :dunno
          end

        type = case read(4, offset + 12).unpack("N")[0]
          when 0x00000002, 0x02000000 then :executable
          when 0x00000006, 0x06000000 then :dylib
          when 0x00000008, 0x08000000 then :bundle
          else :dunno
          end

        mach_data << { :arch => arch, :type => type }
      end
      mach_data
    rescue
      []
    end
  end

  def archs
    mach_data.map{ |m| m.fetch :arch }.extend(ArchitectureListExtension)
  end

  def arch
    case archs.length
    when 0 then :dunno
    when 1 then archs.first
    else :universal
    end
  end

  def universal?
    arch == :universal
  end

  def i386?
    arch == :i386
  end

  def x86_64?
    arch == :x86_64
  end

  def ppc7400?
    arch == :ppc7400
  end

  def ppc64?
    arch == :ppc64
  end

  def dylib?
    mach_data.any? { |m| m.fetch(:type) == :dylib }
  end

  def mach_o_executable?
    mach_data.any? { |m| m.fetch(:type) == :executable }
  end

  def mach_o_bundle?
    mach_data.any? { |m| m.fetch(:type) == :bundle }
  end
end
