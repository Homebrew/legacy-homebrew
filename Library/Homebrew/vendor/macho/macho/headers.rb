module MachO
  # big-endian fat magic
  FAT_MAGIC = 0xcafebabe

  # little-endian fat magic
  FAT_CIGAM = 0xbebafeca

  # 32-bit big-endian magic
  MH_MAGIC = 0xfeedface

  # 32-bit little-endian magic
  MH_CIGAM = 0xcefaedfe

  # 64-bit big-endian magic
  MH_MAGIC_64 = 0xfeedfacf

  # 64-bit little-endian magic
  MH_CIGAM_64 = 0xcffaedfe

  # association of magic numbers to string representations
  MH_MAGICS = {
    FAT_MAGIC => "FAT_MAGIC",
    FAT_CIGAM => "FAT_CIGAM",
    MH_MAGIC => "MH_MAGIC",
    MH_CIGAM => "MH_CIGAM",
    MH_MAGIC_64 => "MH_MAGIC_64",
    MH_CIGAM_64 => "MH_CIGAM_64"
  }

  # mask for CPUs with 64-bit architectures (when running a 64-bit ABI?)
  CPU_ARCH_ABI64 = 0x01000000

  # any CPU (unused?)
  CPU_TYPE_ANY = -1

  # x86 compatible CPUs
  CPU_TYPE_X86 = 0x07

  # i386 and later compatible CPUs
  CPU_TYPE_I386 = CPU_TYPE_X86

  # x86_64 (AMD64) compatible CPUs
  CPU_TYPE_X86_64 = (CPU_TYPE_X86 | CPU_ARCH_ABI64)

  # PowerPC compatible CPUs (7400 series?)
  CPU_TYPE_POWERPC = 0x12

  # PowerPC64 compatible CPUs (970 series?)
  CPU_TYPE_POWERPC64 = (CPU_TYPE_POWERPC | CPU_ARCH_ABI64)

  # association of cpu types to string representations
  CPU_TYPES = {
    CPU_TYPE_ANY => "CPU_TYPE_ANY",
    CPU_TYPE_X86 => "CPU_TYPE_X86",
    CPU_TYPE_I386 => "CPU_TYPE_I386",
    CPU_TYPE_X86_64 => "CPU_TYPE_X86_64",
    CPU_TYPE_POWERPC => "CPU_TYPE_POWERPC",
    CPU_TYPE_POWERPC64 => "CPU_TYPE_POWERPC64"
  }

  # mask for CPU subtype capabilities
  CPU_SUBTYPE_MASK = 0xff000000

  # 64-bit libraries (undocumented!)
  # @see http://llvm.org/docs/doxygen/html/Support_2MachO_8h_source.html
  CPU_SUBTYPE_LIB64 = 0x80000000

  # all x86-type CPUs
  CPU_SUBTYPE_X86_ALL = 3

  # all x86-type CPUs (what makes this different from CPU_SUBTYPE_X86_ALL?)
  CPU_SUBTYPE_X86_ARCH1 = 4

  # association of cpu subtypes to string representations
  CPU_SUBTYPES = {
    CPU_SUBTYPE_X86_ALL => "CPU_SUBTYPE_X86_ALL",
    CPU_SUBTYPE_X86_ARCH1 => "CPU_SUBTYPE_X86_ARCH1"
  }

  # relocatable object file
  MH_OBJECT = 0x1

  # demand paged executable file
  MH_EXECUTE = 0x2

  # fixed VM shared library file
  MH_FVMLIB = 0x3

  # core dump file
  MH_CORE = 0x4

  # preloaded executable file
  MH_PRELOAD = 0x5

  # dynamically bound shared library
  MH_DYLIB = 0x6

  # dynamic link editor
  MH_DYLINKER = 0x7

  # dynamically bound bundle file
  MH_BUNDLE = 0x8

  # shared library stub for static linking only, no section contents
  MH_DYLIB_STUB = 0x9

  # companion file with only debug sections
  MH_DSYM = 0xa

  # x86_64 kexts
  MH_KEXT_BUNDLE = 0xb

  # association of filetypes to string representations
  # @api private
  MH_FILETYPES = {
    MH_OBJECT => "MH_OBJECT",
    MH_EXECUTE => "MH_EXECUTE",
    MH_FVMLIB => "MH_FVMLIB",
    MH_CORE => "MH_CORE",
    MH_PRELOAD => "MH_PRELOAD",
    MH_DYLIB => "MH_DYLIB",
    MH_DYLINKER => "MH_DYLINKER",
    MH_BUNDLE => "MH_BUNDLE",
    MH_DYLIB_STUB => "MH_DYLIB_STUB",
    MH_DSYM => "MH_DSYM",
    MH_KEXT_BUNDLE => "MH_KEXT_BUNDLE"
  }

  # association of mach header flag symbols to values
  # @api private
  MH_FLAGS = {
    :MH_NOUNDEFS => 0x1,
    :MH_INCRLINK => 0x2,
    :MH_DYLDLINK => 0x4,
    :MH_BINDATLOAD => 0x8,
    :MH_PREBOUND => 0x10,
    :MH_SPLIT_SEGS => 0x20,
    :MH_LAZY_INIT => 0x40,
    :MH_TWOLEVEL => 0x80,
    :MH_FORCE_FLAT => 0x100,
    :MH_NOMULTIDEFS => 0x200,
    :MH_NOPREFIXBINDING => 0x400,
    :MH_PREBINDABLE => 0x800,
    :MH_ALLMODSBOUND => 0x1000,
    :MH_SUBSECTIONS_VIA_SYMBOLS => 0x2000,
    :MH_CANONICAL => 0x4000,
    :MH_WEAK_DEFINES => 0x8000,
    :MH_BINDS_TO_WEAK => 0x10000,
    :MH_ALLOW_STACK_EXECUTION => 0x20000,
    :MH_ROOT_SAFE => 0x40000,
    :MH_SETUID_SAFE => 0x80000,
    :MH_NO_REEXPORTED_DYLIBS => 0x100000,
    :MH_PIE => 0x200000,
    :MH_DEAD_STRIPPABLE_DYLIB => 0x400000,
    :MH_HAS_TLV_DESCRIPTORS => 0x800000,
    :MH_NO_HEAP_EXECUTION => 0x1000000,
    :MH_APP_EXTENSION_SAFE => 0x02000000
  }

  # Fat binary header structure
  # @see MachO::FatArch
  class FatHeader < MachOStructure
    # @return [Fixnum] the magic number of the header (and file)
    attr_reader :magic

    # @return [Fixnum] the number of fat architecture structures following the header
    attr_reader :nfat_arch

    FORMAT = "VV"
    SIZEOF = 8

    # @api private
    def initialize(magic, nfat_arch)
      @magic = magic
      @nfat_arch = nfat_arch
    end
  end

  # Fat binary header architecture structure. A Fat binary has one or more of
  # these, representing one or more internal Mach-O blobs.
  # @see MachO::FatHeader
  class FatArch < MachOStructure
    # @return [Fixnum] the CPU type of the Mach-O
    attr_reader :cputype

    # @return [Fixnum] the CPU subtype of the Mach-O
    attr_reader :cpusubtype

    # @return [Fixnum] the file offset to the beginning of the Mach-O data
    attr_reader :offset

    # @return [Fixnum] the size, in bytes, of the Mach-O data
    attr_reader :size

    # @return [Fixnum] the alignment, as a power of 2
    attr_reader :align

    FORMAT = "VVVVV"
    SIZEOF = 20

    # @api private
    def initialize(cputype, cpusubtype, offset, size, align)
      @cputype = cputype
      @cpusubtype = cpusubtype
      @offset = offset
      @size = size
      @align = align
    end
  end

  # 32-bit Mach-O file header structure
  class MachHeader < MachOStructure
    # @return [Fixnum] the magic number
    attr_reader :magic

    # @return [Fixnum] the CPU type of the Mach-O
    attr_reader :cputype

    # @return [Fixnum] the CPU subtype of the Mach-O
    attr_reader :cpusubtype

    # @return [Fixnum] the file type of the Mach-O
    attr_reader :filetype

    # @return [Fixnum] the number of load commands in the Mach-O
    attr_reader :ncmds

    # @return [Fixnum] the size of all load commands, in bytes, in the Mach-O
    attr_reader :sizeofcmds

    # @return [Fixnum] the header flags associated with the Mach-O
    attr_reader :flags

    FORMAT = "VVVVVVV"
    SIZEOF = 28

    # @api private
    def initialize(magic, cputype, cpusubtype, filetype, ncmds, sizeofcmds,
        flags)
      @magic = magic
      @cputype = cputype
      @cpusubtype = cpusubtype
      @filetype = filetype
      @ncmds = ncmds
      @sizeofcmds = sizeofcmds
      @flags = flags
    end

    # @example
    #  puts "this mach-o has position-independent execution" if header.flag?(:MH_PIE)
    # @param flag [Symbol] a mach header flag symbol
    # @return [Boolean] true if `flag` is present in the header's flag section
    def flag?(flag)
      flag = MH_FLAGS[flag]
      return false if flag.nil?
      flags & flag == flag
    end
  end

  # 64-bit Mach-O file header structure
  class MachHeader64 < MachHeader
    # @return [void]
    attr_reader :reserved

    FORMAT = "VVVVVVVV"
    SIZEOF = 32

    # @api private
    def initialize(magic, cputype, cpusubtype, filetype, ncmds, sizeofcmds,
        flags, reserved)
      super(magic, cputype, cpusubtype, filetype, ncmds, sizeofcmds, flags)
      @reserved = reserved
    end
  end
end
