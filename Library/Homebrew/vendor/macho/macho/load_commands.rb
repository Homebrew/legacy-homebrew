module MachO
  # load commands added after OS X 10.1 need to be bitwise ORed with
  # LC_REQ_DYLD to be recognized by the dynamic linder (dyld)
  LC_REQ_DYLD = 0x80000000

  # association of load commands to symbol representations
  # @api private
  LOAD_COMMANDS = {
    0x1 => :LC_SEGMENT,
    0x2 => :LC_SYMTAB,
    0x3 => :LC_SYMSEG,
    0x4 => :LC_THREAD,
    0x5 => :LC_UNIXTHREAD,
    0x6 => :LC_LOADFVMLIB,
    0x7 => :LC_IDFVMLIB,
    0x8 => :LC_IDENT,
    0x9 => :LC_FVMFILE,
    0xa => :LC_PREPAGE,
    0xb => :LC_DYSYMTAB,
    0xc => :LC_LOAD_DYLIB,
    0xd => :LC_ID_DYLIB,
    0xe => :LC_LOAD_DYLINKER,
    0xf => :LC_ID_DYLINKER,
    0x10 => :LC_PREBOUND_DYLIB,
    0x11 => :LC_ROUTINES,
    0x12 => :LC_SUB_FRAMEWORK,
    0x13 => :LC_SUB_UMBRELLA,
    0x14 => :LC_SUB_CLIENT,
    0x15 => :LC_SUB_LIBRARY,
    0x16 => :LC_TWOLEVEL_HINTS,
    0x17 => :LC_PREBIND_CKSUM,
    (0x18 | LC_REQ_DYLD) => :LC_LOAD_WEAK_DYLIB,
    0x19 => :LC_SEGMENT_64,
    0x1a => :LC_ROUTINES_64,
    0x1b => :LC_UUID,
    (0x1c | LC_REQ_DYLD) => :LC_RPATH,
    0x1d => :LC_CODE_SIGNATURE,
    0x1e => :LC_SEGMENT_SPLIT_INFO,
    (0x1f | LC_REQ_DYLD) => :LC_REEXPORT_DYLIB,
    0x20 => :LC_LAZY_LOAD_DYLIB,
    0x21 => :LC_ENCRYPTION_INFO,
    0x22 => :LC_DYLD_INFO,
    (0x22 | LC_REQ_DYLD) => :LC_DYLD_INFO_ONLY,
    (0x23 | LC_REQ_DYLD) => :LC_LOAD_UPWARD_DYLIB,
    0x24 => :LC_VERSION_MIN_MACOSX,
    0x25 => :LC_VERSION_MIN_IPHONEOS,
    0x26 => :LC_FUNCTION_STARTS,
    0x27 => :LC_DYLD_ENVIRONMENT,
    (0x28 | LC_REQ_DYLD) => :LC_MAIN,
    0x29 => :LC_DATA_IN_CODE,
    0x2a => :LC_SOURCE_VERSION,
    0x2b => :LC_DYLIB_CODE_SIGN_DRS,
    0x2c => :LC_ENCRYPTION_INFO_64,
    0x2d => :LC_LINKER_OPTION,
    0x2e => :LC_LINKER_OPTIMIZATION_HINT
  }

  # load commands responsible for loading dylibs
  # @api private
  DYLIB_LOAD_COMMANDS = [
    :LC_LOAD_DYLIB,
    :LC_LOAD_WEAK_DYLIB,
    :LC_REEXPORT_DYLIB,
    :LC_LAZY_LOAD_DYLIB,
    :LC_LOAD_UPWARD_DYLIB,
  ].freeze

  # association of load command symbols to string representations of classes
  # @api private
  LC_STRUCTURES = {
    :LC_SEGMENT => "SegmentCommand",
    :LC_SYMTAB => "SymtabCommand",
    :LC_SYMSEG => "LoadCommand", # obsolete
    :LC_THREAD => "ThreadCommand",
    :LC_UNIXTHREAD => "ThreadCommand",
    :LC_LOADFVMLIB => "LoadCommand", # obsolete
    :LC_IDFVMLIB => "LoadCommand", # obsolete
    :LC_IDENT => "LoadCommand", # obsolete
    :LC_FVMFILE => "LoadCommand", # reserved for internal use only
    :LC_PREPAGE => "LoadCommand", # reserved for internal use only
    :LC_DYSYMTAB => "DysymtabCommand",
    :LC_LOAD_DYLIB => "DylibCommand",
    :LC_ID_DYLIB => "DylibCommand",
    :LC_LOAD_DYLINKER => "DylinkerCommand",
    :LC_ID_DYLINKER => "DylinkerCommand",
    :LC_PREBOUND_DYLIB => "PreboundDylibCommand",
    :LC_ROUTINES => "RoutinesCommand",
    :LC_SUB_FRAMEWORK => "SubFrameworkCommand",
    :LC_SUB_UMBRELLA => "SubUmbrellaCommand",
    :LC_SUB_CLIENT => "SubClientCommand",
    :LC_SUB_LIBRARY => "SubLibraryCommand",
    :LC_TWOLEVEL_HINTS => "TwolevelHintsCommand",
    :LC_PREBIND_CKSUM => "PrebindCksumCommand",
    :LC_LOAD_WEAK_DYLIB => "DylibCommand",
    :LC_SEGMENT_64 => "SegmentCommand64",
    :LC_ROUTINES_64 => "RoutinesCommand64",
    :LC_UUID => "UUIDCommand",
    :LC_RPATH => "RpathCommand",
    :LC_CODE_SIGNATURE => "LinkeditDataCommand",
    :LC_SEGMENT_SPLIT_INFO => "LinkeditDataCommand",
    :LC_REEXPORT_DYLIB => "DylibCommand",
    :LC_LAZY_LOAD_DYLIB => "DylibCommand",
    :LC_ENCRYPTION_INFO => "EncryptionInfoCommand",
    :LC_DYLD_INFO => "DyldInfoCommand",
    :LC_DYLD_INFO_ONLY => "DyldInfoCommand",
    :LC_LOAD_UPWARD_DYLIB => "DylibCommand",
    :LC_VERSION_MIN_MACOSX => "VersionMinCommand",
    :LC_VERSION_MIN_IPHONEOS => "VersionMinCommand",
    :LC_FUNCTION_STARTS => "LinkeditDataCommand",
    :LC_DYLD_ENVIRONMENT => "DylinkerCommand",
    :LC_MAIN => "EntryPointCommand",
    :LC_DATA_IN_CODE => "LinkeditDataCommand",
    :LC_SOURCE_VERSION => "SourceVersionCommand",
    :LC_DYLIB_CODE_SIGN_DRS => "LinkeditDataCommand",
    :LC_ENCRYPTION_INFO_64 => "EncryptionInfoCommand64",
    :LC_LINKER_OPTION => "LinkerOptionCommand",
    :LC_LINKER_OPTIMIZATION_HINT => "LinkeditDataCommand"
  }

  # association of segment name symbols to names
  # @api private
  SEGMENT_NAMES = {
    :SEG_PAGEZERO => "__PAGEZERO",
    :SEG_TEXT => "__TEXT",
    :SEG_DATA => "__DATA",
    :SEG_OBJC => "__OBJC",
    :SEG_ICON => "__ICON",
    :SEG_LINKEDIT => "__LINKEDIT",
    :SEG_UNIXSTACK => "__UNIXSTACK",
    :SEG_IMPORT => "__IMPORT"
  }

  # association of segment flag symbols to values
  # @api private
  SEGMENT_FLAGS = {
    :SG_HIGHVM => 0x1,
    :SG_FVMLIB => 0x2,
    :SG_NORELOC => 0x4,
    :SG_PROTECTED_VERSION_1 => 0x8
  }

  # Mach-O load command structure
  # This is the most generic load command - only cmd ID and size are
  # represented, and no actual data. Used when a more specific class
  # isn't available/implemented.
  class LoadCommand < MachOStructure
    # @return [Fixnum] the offset in the file the command was created from
    attr_reader :offset

    # @return [Fixnum] the load command's identifying number
    attr_reader :cmd

    # @return [Fixnum] the size of the load command, in bytes
    attr_reader :cmdsize

    FORMAT = "VV"
    SIZEOF = 8

    # Creates a new LoadCommand given an offset and binary string
    # @param offset [Fixnum] the offset to initialize with
    # @param bin [String] the binary string to initialize with
    # @return [MachO::LoadCommand] the new load command
    # @api private
    def self.new_from_bin(raw_data, offset, bin)
      self.new(raw_data, offset, *bin.unpack(self::FORMAT))
    end

    # @param offset [Fixnum] the offset to initialize with
    # @param cmd [Fixnum] the load command's identifying number
    # @param cmdsize [Fixnum] the size of the load command in bytes
    # @api private
    def initialize(raw_data, offset, cmd, cmdsize)
      @raw_data = raw_data
      @offset = offset
      @cmd = cmd
      @cmdsize = cmdsize
    end

    # @return [Symbol] a symbol representation of the load command's identifying number
    def type
      LOAD_COMMANDS[cmd]
    end

    alias :to_sym :type

    # @return [String] a string representation of the load command's identifying number
    def to_s
      type.to_s
    end

    # Represents a Load Command string. A rough analogue to the lc_str
    # struct used internally by OS X. This class allows ruby-macho to
    # pretend that strings stored in LCs are immediately available without
    # explicit operations on the raw Mach-O data.
    class LCStr
      # @param raw_data [String] the raw Mach-O data.
      # @param lc [MachO::LoadCommand] the load command
      # @param lc_str [Fixnum] the offset to the beginning of the string
      # @api private
      def initialize(raw_data, lc, lc_str)
        @raw_data = raw_data
        @lc = lc
        @lc_str = lc_str
        @str = @raw_data.slice(@lc.offset + @lc_str...@lc.offset + @lc.cmdsize).delete("\x00")
      end

      # @return [String] a string representation of the LCStr
      def to_s
        @str
      end

      # @return [Fixnum] the offset to the beginning of the string in the load command
      def to_i
        @lc_str
      end
    end
  end

  # A load command containing a single 128-bit unique random number identifying
  # an object produced by static link editor. Corresponds to LC_UUID.
  class UUIDCommand < LoadCommand
    # @return [Array<Fixnum>] the UUID
    attr_reader :uuid

    FORMAT = "VVa16"
    SIZEOF = 24

    # @api private
    def initialize(raw_data, offset, cmd, cmdsize, uuid)
      super(raw_data, offset, cmd, cmdsize)
      @uuid = uuid.unpack("C16") # re-unpack for the actual UUID array
    end

    # @return [String] a string representation of the UUID
    def uuid_string
      hexes = uuid.map { |e| "%02x" % e }
      segs = [
        hexes[0..3].join, hexes[4..5].join, hexes[6..7].join,
        hexes[8..9].join, hexes[10..15].join
      ]

      segs.join("-")
    end
  end

  # A load command indicating that part of this file is to be mapped into
  # the task's address space. Corresponds to LC_SEGMENT.
  class SegmentCommand < LoadCommand
    # @return [String] the name of the segment
    attr_reader :segname

    # @return [Fixnum] the memory address of the segment
    attr_reader :vmaddr

    # @return [Fixnum] the memory size of the segment
    attr_reader :vmsize

    # @return [Fixnum] the file offset of the segment
    attr_reader :fileoff

    # @return [Fixnum] the amount to map from the file
    attr_reader :filesize

    # @return [Fixnum] the maximum VM protection
    attr_reader :maxprot

    # @return [Fixnum] the initial VM protection
    attr_reader :initprot

    # @return [Fixnum] the number of sections in the segment
    attr_reader :nsects

    # @return [Fixnum] any flags associated with the segment
    attr_reader :flags

    FORMAT = "VVa16VVVVVVVV"
    SIZEOF = 56

    # @api private
    def initialize(raw_data, offset, cmd, cmdsize, segname, vmaddr, vmsize, fileoff,
        filesize, maxprot, initprot, nsects, flags)
      super(raw_data, offset, cmd, cmdsize)
      @segname = segname.delete("\x00")
      @vmaddr = vmaddr
      @vmsize = vmsize
      @fileoff = fileoff
      @filesize = filesize
      @maxprot = maxprot
      @initprot = initprot
      @nsects = nsects
      @flags = flags
    end

    # @example
    #  puts "this segment relocated in/to it" if sect.flag?(:SG_NORELOC)
    # @param flag [Symbol] a segment flag symbol
    # @return [Boolean] true if `flag` is present in the segment's flag field
    def flag?(flag)
      flag = SEGMENT_FLAGS[flag]
      return false if flag.nil?
      flags & flag == flag
    end
  end

  # A load command indicating that part of this file is to be mapped into
  # the task's address space. Corresponds to LC_SEGMENT_64.
  class SegmentCommand64 < LoadCommand
    # @return [String] the name of the segment
    attr_reader :segname

    # @return [Fixnum] the memory address of the segment
    attr_reader :vmaddr

    # @return [Fixnum] the memory size of the segment
    attr_reader :vmsize

    # @return [Fixnum] the file offset of the segment
    attr_reader :fileoff

    # @return [Fixnum] the amount to map from the file
    attr_reader :filesize

    # @return [Fixnum] the maximum VM protection
    attr_reader :maxprot

    # @return [Fixnum] the initial VM protection
    attr_reader :initprot

    # @return [Fixnum] the number of sections in the segment
    attr_reader :nsects

    # @return [Fixnum] any flags associated with the segment
    attr_reader :flags

    FORMAT = "VVa16QQQQVVVV"
    SIZEOF = 72

    # @api private
    def initialize(raw_data, offset, cmd, cmdsize, segname, vmaddr, vmsize, fileoff,
        filesize, maxprot, initprot, nsects, flags)
      super(raw_data, offset, cmd, cmdsize)
      @segname = segname.delete("\x00")
      @vmaddr = vmaddr
      @vmsize = vmsize
      @fileoff = fileoff
      @filesize = filesize
      @maxprot = maxprot
      @initprot = initprot
      @nsects = nsects
      @flags = flags
    end

    # @example
    #  puts "this segment relocated in/to it" if sect.flag?(:SG_NORELOC)
    # @param flag [Symbol] a segment flag symbol
    # @return [Boolean] true if `flag` is present in the segment's flag field
    def flag?(flag)
      flag = SEGMENT_FLAGS[flag]
      return false if flag.nil?
      flags & flag == flag
    end
  end

  # A load command representing some aspect of shared libraries, depending
  # on filetype. Corresponds to LC_ID_DYLIB, LC_LOAD_DYLIB, LC_LOAD_WEAK_DYLIB,
  # and LC_REEXPORT_DYLIB.
  class DylibCommand < LoadCommand
    # @return [MachO::LoadCommand::LCStr] the library's path name as an LCStr
    attr_reader :name

    # @return [Fixnum] the library's build time stamp
    attr_reader :timestamp

    # @return [Fixnum] the library's current version number
    attr_reader :current_version

    # @return [Fixnum] the library's compatibility version number
    attr_reader :compatibility_version

    FORMAT = "VVVVVV"
    SIZEOF = 24

    # @api private
    def initialize(raw_data, offset, cmd, cmdsize, name, timestamp, current_version,
        compatibility_version)
      super(raw_data, offset, cmd, cmdsize)
      @name = LCStr.new(raw_data, self, name)
      @timestamp = timestamp
      @current_version = current_version
      @compatibility_version = compatibility_version
    end
  end

  # A load command representing some aspect of the dynamic linker, depending
  # on filetype. Corresponds to LC_ID_DYLINKER, LC_LOAD_DYLINKER, and
  # LC_DYLD_ENVIRONMENT.
  class DylinkerCommand < LoadCommand
    # @return [MachO::LoadCommand::LCStr] the dynamic linker's path name as an LCStr
    attr_reader :name

    FORMAT = "VVV"
    SIZEOF = 12

    # @api private
    def initialize(raw_data, offset, cmd, cmdsize, name)
      super(raw_data, offset, cmd, cmdsize)
      @name = LCStr.new(raw_data, self, name)
    end
  end

  # A load command used to indicate dynamic libraries used in prebinding.
  # Corresponds to LC_PREBOUND_DYLIB.
  class PreboundDylibCommand < LoadCommand
    # @return [MachO::LoadCommand::LCStr] the library's path name as an LCStr
    attr_reader :name

    # @return [Fixnum] the number of modules in the library
    attr_reader :nmodules

    # @return [Fixnum] a bit vector of linked modules
    attr_reader :linked_modules

    FORMAT = "VVVVV"
    SIZEOF = 20

    # @api private
    def initialize(raw_data, offset, cmd, cmdsize, name, nmodules, linked_modules)
      super(raw_data, offset, cmd, cmdsize)
      @name = LCStr.new(raw_data, self, name)
      @nmodules = nmodules
      @linked_modules = linked_modules
    end
  end

  # A load command used to represent threads.
  # @note cctools-870 has all fields of thread_command commented out except common ones (cmd, cmdsize)
  class ThreadCommand < LoadCommand

  end

  # A load command containing the address of the dynamic shared library
  # initialization routine and an index into the module table for the module
  # that defines the routine. Corresponds to LC_ROUTINES.
  class RoutinesCommand < LoadCommand
    # @return [Fixnum] the address of the initialization routine
    attr_reader :init_address

    # @return [Fixnum] the index into the module table that the init routine is defined in
    attr_reader :init_module

    # @return [void]
    attr_reader :reserved1

    # @return [void]
    attr_reader :reserved2

    # @return [void]
    attr_reader :reserved3

    # @return [void]
    attr_reader :reserved4

    # @return [void]
    attr_reader :reserved5

    # @return [void]
    attr_reader :reserved6

    FORMAT = "VVVVVVVVVV"
    SIZEOF = 40

    # @api private
    def initialize(raw_data, offset, cmd, cmdsize, init_address, init_module,
        reserved1, reserved2, reserved3, reserved4, reserved5,
        reserved6)
      super(raw_data, offset, cmd, cmdsize)
      @init_address = init_address
      @init_module = init_module
      @reserved1 = reserved1
      @reserved2 = reserved2
      @reserved3 = reserved3
      @reserved4 = reserved4
      @reserved5 = reserved5
      @reserved6 = reserved6
    end
  end

  # A load command containing the address of the dynamic shared library
  # initialization routine and an index into the module table for the module
  # that defines the routine. Corresponds to LC_ROUTINES_64.
  class RoutinesCommand64 < LoadCommand
    # @return [Fixnum] the address of the initialization routine
    attr_reader :init_address

    # @return [Fixnum] the index into the module table that the init routine is defined in
    attr_reader :init_module

    # @return [void]
    attr_reader :reserved1

    # @return [void]
    attr_reader :reserved2

    # @return [void]
    attr_reader :reserved3

    # @return [void]
    attr_reader :reserved4

    # @return [void]
    attr_reader :reserved5

    # @return [void]
    attr_reader :reserved6

    FORMAT = "VVQQQQQQQQ"
    SIZEOF = 72

    # @api private
    def initialize(raw_data, offset, cmd, cmdsize, init_address, init_module,
        reserved1, reserved2, reserved3, reserved4, reserved5,
        reserved6)
      super(raw_data, offset, cmd, cmdsize)
      @init_address = init_address
      @init_module = init_module
      @reserved1 = reserved1
      @reserved2 = reserved2
      @reserved3 = reserved3
      @reserved4 = reserved4
      @reserved5 = reserved5
      @reserved6 = reserved6
    end
  end

  # A load command signifying membership of a subframework containing the name
  # of an umbrella framework. Corresponds to LC_SUB_FRAMEWORK.
  class SubFrameworkCommand < LoadCommand
    # @return [MachO::LoadCommand::LCStr] the umbrella framework name as an LCStr
    attr_reader :umbrella

    FORMAT = "VVV"
    SIZEOF = 12

    # @api private
    def initialize(raw_data, offset, cmd, cmdsize, umbrella)
      super(raw_data, offset, cmd, cmdsize)
      @umbrella = LCStr.new(raw_data, self, umbrella)
    end
  end

  # A load command signifying membership of a subumbrella containing the name
  # of an umbrella framework. Corresponds to LC_SUB_UMBRELLA.
  class SubUmbrellaCommand < LoadCommand
    # @return [MachO::LoadCommand::LCStr] the subumbrella framework name as an LCStr
    attr_reader :sub_umbrella

    FORMAT = "VVV"
    SIZEOF = 12

    # @api private
    def initialize(raw_data, offset, cmd, cmdsize, sub_umbrella)
      super(raw_data, offset, cmd, cmdsize)
      @sub_umbrella = LCStr.new(raw_data, self, sub_umbrella)
    end
  end

  # A load command signifying a sublibrary of a shared library. Corresponds
  # to LC_SUB_LIBRARY.
  class SubLibraryCommand < LoadCommand
    # @return [MachO::LoadCommand::LCStr] the sublibrary name as an LCStr
    attr_reader :sub_library

    FORMAT = "VVV"
    SIZEOF = 12

    # @api private
    def initialize(raw_data, offset, cmd, cmdsize, sub_library)
      super(raw_data, offset, cmd, cmdsize)
      @sub_library = LCStr.new(raw_data, self, sub_library)
    end
  end

  # A load command signifying a shared library that is a subframework of
  # an umbrella framework. Corresponds to LC_SUB_CLIENT.
  class SubClientCommand < LoadCommand
    # @return [MachO::LoadCommand::LCStr] the subclient name as an LCStr
    attr_reader :sub_client

    FORMAT = "VVV"
    SIZEOF = 12

    # @api private
    def initialize(raw_data, offset, cmd, cmdsize, sub_client)
      super(raw_data, offset, cmd, cmdsize)
      @sub_client = LCStr.new(raw_data, self, sub_client)
    end
  end

  # A load command containing the offsets and sizes of the link-edit 4.3BSD
  # "stab" style symbol table information. Corresponds to LC_SYMTAB.
  class SymtabCommand < LoadCommand
    # @return [Fixnum] the symbol table's offset
    attr_reader :symoff

    # @return [Fixnum] the number of symbol table entries
    attr_reader :nsyms

    # @return the string table's offset
    attr_reader :stroff

    # @return the string table size in bytes
    attr_reader :strsize

    FORMAT = "VVVVVV"
    SIZEOF = 24

    # @api private
    def initialize(raw_data, offset, cmd, cmdsize, symoff, nsyms, stroff, strsize)
      super(raw_data, offset, cmd, cmdsize)
      @symoff = symoff
      @nsyms = nsyms
      @stroff = stroff
      @strsize = strsize
    end
  end

  # A load command containing symbolic information needed to support data
  # structures used by the dynamic link editor. Corresponds to LC_DYSYMTAB.
  class DysymtabCommand < LoadCommand
    # @return [Fixnum] the index to local symbols
    attr_reader :ilocalsym

    # @return [Fixnum] the number of local symbols
    attr_reader :nlocalsym

    # @return [Fixnum] the index to externally defined symbols
    attr_reader :iextdefsym

    # @return [Fixnum] the number of externally defined symbols
    attr_reader :nextdefsym

    # @return [Fixnum] the index to undefined symbols
    attr_reader :iundefsym

    # @return [Fixnum] the number of undefined symbols
    attr_reader :nundefsym

    # @return [Fixnum] the file offset to the table of contents
    attr_reader :tocoff

    # @return [Fixnum] the number of entries in the table of contents
    attr_reader :ntoc

    # @return [Fixnum] the file offset to the module table
    attr_reader :modtaboff

    # @return [Fixnum] the number of entries in the module table
    attr_reader :nmodtab

    # @return [Fixnum] the file offset to the referenced symbol table
    attr_reader :extrefsymoff

    # @return [Fixnum] the number of entries in the referenced symbol table
    attr_reader :nextrefsyms

    # @return [Fixnum] the file offset to the indirect symbol table
    attr_reader :indirectsymoff

    # @return [Fixnum] the number of entries in the indirect symbol table
    attr_reader :nindirectsyms

    # @return [Fixnum] the file offset to the external relocation entries
    attr_reader :extreloff

    # @return [Fixnum] the number of external relocation entries
    attr_reader :nextrel

    # @return [Fixnum] the file offset to the local relocation entries
    attr_reader :locreloff

    # @return [Fixnum] the number of local relocation entries
    attr_reader :nlocrel


    FORMAT = "VVVVVVVVVVVVVVVVVVVV"
    SIZEOF = 80

    # ugh
    # @api private
    def initialize(raw_data, offset, cmd, cmdsize, ilocalsym, nlocalsym, iextdefsym,
        nextdefsym, iundefsym, nundefsym, tocoff, ntoc, modtaboff,
        nmodtab, extrefsymoff, nextrefsyms, indirectsymoff,
        nindirectsyms, extreloff, nextrel, locreloff, nlocrel)
      super(raw_data, offset, cmd, cmdsize)
      @ilocalsym = ilocalsym
      @nlocalsym = nlocalsym
      @iextdefsym = iextdefsym
      @nextdefsym = nextdefsym
      @iundefsym = iundefsym
      @nundefsym = nundefsym
      @tocoff = tocoff
      @ntoc = ntoc
      @modtaboff = modtaboff
      @nmodtab = nmodtab
      @extrefsymoff = extrefsymoff
      @nextrefsyms = nextrefsyms
      @indirectsymoff = indirectsymoff
      @nindirectsyms = nindirectsyms
      @extreloff = extreloff
      @nextrel = nextrel
      @locreloff = locreloff
      @nlocrel = nlocrel
    end
  end

  # A load command containing the offset and number of hints in the two-level
  # namespace lookup hints table. Corresponds to LC_TWOLEVEL_HINTS.
  class TwolevelHintsCommand < LoadCommand
    # @return [Fixnum] the offset to the hint table
    attr_reader :htoffset

    # @return [Fixnum] the number of hints in the hint table
    attr_reader :nhints

    FORMAT = "VVVV"
    SIZEOF = 16

    # @api private
    def initialize(raw_data, offset, cmd, cmdsize, htoffset, nhints)
      super(raw_data, offset, cmd, cmdsize)
      @htoffset = htoffset
      @nhints = nhints
    end
  end

  # A load command containing the value of the original checksum for prebound
  # files, or zero. Corresponds to LC_PREBIND_CKSUM.
  class PrebindCksumCommand < LoadCommand
    # @return [Fixnum] the checksum or 0
    attr_reader :cksum

    FORMAT = "VVV"
    SIZEOF = 12

    # @api private
    def initialize(raw_data, offset, cmd, cmdsize, cksum)
      super(raw_data, offset, cmd, cmdsize)
      @cksum = cksum
    end
  end

  # A load command representing an rpath, which specifies a path that should
  # be added to the current run path used to find @rpath prefixed dylibs.
  # Corresponds to LC_RPATH.
  class RpathCommand < LoadCommand
    # @return [MachO::LoadCommand::LCStr] the path to add to the run path as an LCStr
    attr_reader :path

    FORMAT = "VVV"
    SIZEOF = 12

    # @api private
    def initialize(raw_data, offset, cmd, cmdsize, path)
      super(raw_data, offset, cmd, cmdsize)
      @path = LCStr.new(raw_data, self, path)
    end
  end

  # A load command representing the offsets and sizes of a blob of data in
  # the __LINKEDIT segment. Corresponds to LC_CODE_SIGNATURE, LC_SEGMENT_SPLIT_INFO,
  # LC_FUNCTION_STARTS, LC_DATA_IN_CODE, LC_DYLIB_CODE_SIGN_DRS, and LC_LINKER_OPTIMIZATION_HINT.
  class LinkeditDataCommand < LoadCommand
    # @return [Fixnum] offset to the data in the __LINKEDIT segment
    attr_reader :dataoff

    # @return [Fixnum] size of the data in the __LINKEDIT segment
    attr_reader :datasize

    FORMAT = "VVVV"
    SIZEOF = 16

    # @api private
    def initialize(raw_data, offset, cmd, cmdsize, dataoff, datasize)
      super(raw_data, offset, cmd, cmdsize)
      @dataoff = dataoff
      @datasize = datasize
    end
  end

  # A load command representing the offset to and size of an encrypted
  # segment. Corresponds to LC_ENCRYPTION_INFO.
  class EncryptionInfoCommand < LoadCommand
    # @return [Fixnum] the offset to the encrypted segment
    attr_reader :cryptoff

    # @return [Fixnum] the size of the encrypted segment
    attr_reader :cryptsize

    # @return [Fixnum] the encryption system, or 0 if not encrypted yet
    attr_reader :cryptid

    FORMAT = "VVVVV"
    SIZEOF = 20

    # @api private
    def initialize(raw_data, offset, cmd, cmdsize, cryptoff, cryptsize, cryptid)
      super(raw_data, offset, cmd, cmdsize)
      @cryptoff = cryptoff
      @cryptsize = cryptsize
      @cryptid = cryptid
    end
  end

  # A load command representing the offset to and size of an encrypted
  # segment. Corresponds to LC_ENCRYPTION_INFO_64.
  class EncryptionInfoCommand64 < LoadCommand
    # @return [Fixnum] the offset to the encrypted segment
    attr_reader :cryptoff

    # @return [Fixnum] the size of the encrypted segment
    attr_reader :cryptsize

    # @return [Fixnum] the encryption system, or 0 if not encrypted yet
    attr_reader :cryptid

    # @return [Fixnum] 64-bit padding value
    attr_reader :pad

    FORMAT = "VVVVVV"
    SIZEOF = 24

    # @api private
    def initialize(raw_data, offset, cmd, cmdsize, cryptoff, cryptsize, cryptid, pad)
      super(raw_data, offset, cmd, cmdsize)
      @cryptoff = cryptoff
      @cryptsize = cryptsize
      @cryptid = cryptid
      @pad = pad
    end
  end

  # A load command containing the minimum OS version on which the binary
  # was built to run. Corresponds to LC_VERSION_MIN_MACOSX and LC_VERSION_MIN_IPHONEOS.
  class VersionMinCommand < LoadCommand
    # @return [Fixnum] the version X.Y.Z packed as x16.y8.z8
    attr_reader :version

    # @return [Fixnum] the SDK version X.Y.Z packed as x16.y8.z8
    attr_reader :sdk

    FORMAT = "VVVV"
    SIZEOF = 16

    # @api private
    def initialize(raw_data, offset, cmd, cmdsize, version, sdk)
      super(raw_data, offset, cmd, cmdsize)
      @version = version
      @sdk = sdk
    end

    # A string representation of the binary's minimum OS version.
    # @return [String] a string representing the minimum OS version.
    def version_string
      binary = "%032b" % version
      segs = [
        binary[0..15], binary[16..23], binary[24..31]
      ].map { |s| s.to_i(2) }

      segs.join(".")
    end

    # A string representation of the binary's SDK version.
    # @return [String] a string representing the SDK version.
    def sdk_string
      binary = "%032b" % sdk
      segs = [
        binary[0..15], binary[16..23], binary[24..31]
      ].map { |s| s.to_i(2) }

      segs.join(".")
    end
  end

  # A load command containing the file offsets and sizes of the new
  # compressed form of the information dyld needs to load the image.
  # Corresponds to LC_DYLD_INFO and LC_DYLD_INFO_ONLY.
  class DyldInfoCommand < LoadCommand
    # @return [Fixnum] the file offset to the rebase information
    attr_reader :rebase_off

    # @return [Fixnum] the size of the rebase information
    attr_reader :rebase_size

    # @return [Fixnum] the file offset to the binding information
    attr_reader :bind_off

    # @return [Fixnum] the size of the binding information
    attr_reader :bind_size

    # @return [Fixnum] the file offset to the weak binding information
    attr_reader :weak_bind_off

    # @return [Fixnum] the size of the weak binding information
    attr_reader :weak_bind_size

    # @return [Fixnum] the file offset to the lazy binding information
    attr_reader :lazy_bind_off

    # @return [Fixnum] the size of the lazy binding information
    attr_reader :lazy_bind_size

    # @return [Fixnum] the file offset to the export information
    attr_reader :export_off

    # @return [Fixnum] the size of the export information
    attr_reader :export_size

    FORMAT = "VVVVVVVVVVVV"
    SIZEOF = 48

    # @api private
    def initialize(raw_data, offset, cmd, cmdsize, rebase_off, rebase_size, bind_off,
        bind_size, weak_bind_off, weak_bind_size, lazy_bind_off,
        lazy_bind_size, export_off, export_size)
      super(raw_data, offset, cmd, cmdsize)
      @rebase_off = rebase_off
      @rebase_size = rebase_size
      @bind_off = bind_off
      @bind_size = bind_size
      @weak_bind_off = weak_bind_off
      @weak_bind_size = weak_bind_size
      @lazy_bind_off = lazy_bind_off
      @lazy_bind_size = lazy_bind_size
      @export_off = export_off
      @export_size = export_size
    end
  end

  # A load command containing linker options embedded in object files.
  # Corresponds to LC_LINKER_OPTION.
  class LinkerOptionCommand < LoadCommand
    # @return [Fixnum] the number of strings
    attr_reader :count

    FORMAT = "VVV"
    SIZEOF = 12

    # @api private
    def initialize(raw_data, offset, cmd, cmdsize, count)
      super(raw_data, offset, cmd, cmdsize)
      @count = count
    end
  end

  # A load command specifying the offset of main(). Corresponds to LC_MAIN.
  class EntryPointCommand < LoadCommand
    # @return [Fixnum] the file (__TEXT) offset of main()
    attr_reader :entryoff

    # @return [Fixnum] if not 0, the initial stack size.
    attr_reader :stacksize

    FORMAT = "VVQQ"
    SIZEOF = 24

    # @api private
    def initialize(raw_data, offset, cmd, cmdsize, entryoff, stacksize)
      super(raw_data, offset, cmd, cmdsize)
      @entryoff = entryoff
      @stacksize = stacksize
    end
  end

  # A load command specifying the version of the sources used to build the
  # binary. Corresponds to LC_SOURCE_VERSION.
  class SourceVersionCommand < LoadCommand
    # @return [Fixnum] the version packed as a24.b10.c10.d10.e10
    attr_reader :version

    FORMAT = "VVQ"
    SIZEOF = 16

    # @api private
    def initialize(raw_data, offset, cmd, cmdsize, version)
      super(raw_data, offset, cmd, cmdsize)
      @version = version
    end

    # A string representation of the sources used to build the binary.
    # @return [String] a string representation of the version
    def version_string
      binary = "%064b" % version
      segs = [
        binary[0..23], binary[24..33], binary[34..43], binary[44..53],
        binary[54..63]
      ].map { |s| s.to_i(2) }

      segs.join(".")
    end
  end
end
