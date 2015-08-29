module ArchitectureListExtension
  # @private
  def fat?
    length > 1
  end

  # @private
  def intel_universal?
    intersects_all?(Hardware::CPU::INTEL_32BIT_ARCHS, Hardware::CPU::INTEL_64BIT_ARCHS)
  end

  # @private
  def ppc_universal?
    intersects_all?(Hardware::CPU::PPC_32BIT_ARCHS, Hardware::CPU::PPC_64BIT_ARCHS)
  end

  # Old-style 32-bit PPC/Intel universal, e.g. ppc7400 and i386
  # @private
  def cross_universal?
    intersects_all?(Hardware::CPU::PPC_32BIT_ARCHS, Hardware::CPU::INTEL_32BIT_ARCHS)
  end

  # @private
  def universal?
    intel_universal? || ppc_universal? || cross_universal?
  end

  def ppc?
    (Hardware::CPU::PPC_32BIT_ARCHS+Hardware::CPU::PPC_64BIT_ARCHS).any? { |a| self.include? a }
  end

  # @private
  def remove_ppc!
    (Hardware::CPU::PPC_32BIT_ARCHS+Hardware::CPU::PPC_64BIT_ARCHS).each { |a| delete a }
  end

  def as_arch_flags
    collect { |a| "-arch #{a}" }.join(" ")
  end

  def as_cmake_arch_flags
    join(";")
  end

  protected

  def intersects_all?(*set)
    set.all? do |archset|
      archset.any? { |a| self.include? a }
    end
  end
end

module MachO
  # @private
  OTOOL_RX = /\t(.*) \(compatibility version (?:\d+\.)*\d+, current version (?:\d+\.)*\d+\)/

  # Mach-O binary methods, see:
  # /usr/include/mach-o/loader.h
  # /usr/include/mach-o/fat.h
  # @private
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
    mach_data.map { |m| m.fetch :arch }.extend(ArchitectureListExtension)
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

  # @private
  def dylib?
    mach_data.any? { |m| m.fetch(:type) == :dylib }
  end

  # @private
  def mach_o_executable?
    mach_data.any? { |m| m.fetch(:type) == :executable }
  end

  # @private
  def mach_o_bundle?
    mach_data.any? { |m| m.fetch(:type) == :bundle }
  end

  # @private
  class Metadata
    attr_reader :path, :dylib_id, :dylibs

    def initialize(path)
      @path = path
      @dylib_id, @dylibs = parse_otool_L_output
    end

    def parse_otool_L_output
      ENV["HOMEBREW_MACH_O_FILE"] = path.expand_path.to_s
      libs = `#{MacOS.otool} -L "$HOMEBREW_MACH_O_FILE"`.split("\n")
      unless $?.success?
        raise ErrorDuringExecution.new(MacOS.otool,
          ["-L", ENV["HOMEBREW_MACH_O_FILE"]])
      end

      libs.shift # first line is the filename

      id = libs.shift[OTOOL_RX, 1] if path.dylib?
      libs.map! { |lib| lib[OTOOL_RX, 1] }.compact!

      return id, libs
    ensure
      ENV.delete "HOMEBREW_MACH_O_FILE"
    end
  end

  # @private
  def mach_metadata
    @mach_metadata ||= Metadata.new(self)
  end

  # Returns an array containing all dynamically-linked libraries, based on the
  # output of otool. This returns the install names, so these are not guaranteed
  # to be absolute paths.
  # Returns an empty array both for software that links against no libraries,
  # and for non-mach objects.
  # @private
  def dynamically_linked_libraries
    mach_metadata.dylibs
  end

  # @private
  def dylib_id
    mach_metadata.dylib_id
  end
end
