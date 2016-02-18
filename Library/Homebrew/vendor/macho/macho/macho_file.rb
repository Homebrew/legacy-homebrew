module MachO
  # Represents a Mach-O file, which contains a header and load commands
  # as well as binary executable instructions. Mach-O binaries are
  # architecture specific.
  # @see https://en.wikipedia.org/wiki/Mach-O
  # @see MachO::FatFile
  class MachOFile
    # @return [MachO::MachHeader] if the Mach-O is 32-bit
    # @return [MachO::MachHeader64] if the Mach-O is 64-bit
    attr_reader :header

    # @return [Array<MachO::LoadCommand>] an array of the file's load commands
    attr_reader :load_commands

    # Creates a new MachOFile instance from a binary string.
    # @param bin [String] a binary string containing raw Mach-O data
    # @return [MachO::MachOFile] a new MachOFile
    def self.new_from_bin(bin)
      instance = allocate
      instance.initialize_from_bin(bin)

      instance
    end

    # Creates a new FatFile from the given filename.
    # @param filename [String] the Mach-O file to load from
    # @raise [ArgumentError] if the given filename does not exist
    def initialize(filename)
      raise ArgumentError.new("#{filetype}: no such file") unless File.exist?(filename)

      @filename = filename
      @raw_data = open(@filename, "rb") { |f| f.read }
      @header = get_mach_header
      @load_commands = get_load_commands
    end

    # @api private
    def initialize_from_bin(bin)
      @filename = nil
      @raw_data = bin
      @header = get_mach_header
      @load_commands = get_load_commands
    end

    # The file's raw Mach-O data.
    # @return [String] the raw Mach-O data
    def serialize
      @raw_data
    end

    # @return [Boolean] true if the Mach-O has 32-bit magic, false otherwise
    def magic32?
      MachO.magic32?(header.magic)
    end

    # @return [Boolean] true if the Mach-O has 64-bit magic, false otherwise
    def magic64?
      MachO.magic64?(header.magic)
    end

    # @return [Boolean] true if the file is of type `MH_OBJECT`, false otherwise
    def object?
      header.filetype == MH_OBJECT
    end

    # @return [Boolean] true if the file is of type `MH_EXECUTE`, false otherwise
    def executable?
      header.filetype == MH_EXECUTE
    end

    # @return [Boolean] true if the file is of type `MH_FVMLIB`, false otherwise
    def fvmlib?
      header.filetype == MH_FVMLIB
    end

    # @return [Boolean] true if the file is of type `MH_CORE`, false otherwise
    def core?
      header.filetype == MH_CORE
    end

    # @return [Boolean] true if the file is of type `MH_PRELOAD`, false otherwise
    def preload?
      header.filetype == MH_PRELOAD
    end

    # @return [Boolean] true if the file is of type `MH_DYLIB`, false otherwise
    def dylib?
      header.filetype == MH_DYLIB
    end

    # @return [Boolean] true if the file is of type `MH_DYLINKER`, false otherwise
    def dylinker?
      header.filetype == MH_DYLINKER
    end

    # @return [Boolean] true if the file is of type `MH_BUNDLE`, false otherwise
    def bundle?
      header.filetype == MH_BUNDLE
    end

    # @return [Boolean] true if the file is of type `MH_DSYM`, false otherwise
    def dsym?
      header.filetype == MH_DSYM
    end

    # @return [Boolean] true if the file is of type `MH_KEXT_BUNDLE`, false otherwise
    def kext?
      header.filetype == MH_KEXT_BUNDLE
    end

    # @return [Fixnum] the file's magic number
    def magic
      header.magic
    end

    # @return [String] a string representation of the file's magic number
    def magic_string
      MH_MAGICS[magic]
    end

    # @return [String] a string representation of the Mach-O's filetype
    def filetype
      MH_FILETYPES[header.filetype]
    end

    # @return [String] a string representation of the Mach-O's CPU type
    def cputype
      CPU_TYPES[header.cputype]
    end

    # @return [String] a string representation of the Mach-O's CPU subtype
    def cpusubtype
      CPU_SUBTYPES[header.cpusubtype]
    end

    # @return [Fixnum] the number of load commands in the Mach-O's header
    def ncmds
      header.ncmds
    end

    # @return [Fixnum] the size of all load commands, in bytes
    def sizeofcmds
      header.sizeofcmds
    end

    # @return [Fixnum] execution flags set by the linker
    def flags
      header.flags
    end

    # All load commands of a given name.
    # @example
    #  file.command("LC_LOAD_DYLIB")
    #  file[:LC_LOAD_DYLIB]
    # @param [String, Symbol] name the load command ID
    # @return [Array<MachO::LoadCommand>] an array of LoadCommands corresponding to `name`
    def command(name)
      load_commands.select { |lc| lc.type == name.to_sym }
    end

    alias :[] :command

    # All load commands responsible for loading dylibs.
    # @return [Array<MachO::DylibCommand>] an array of DylibCommands
    def dylib_load_commands
      load_commands.select { |lc| DYLIB_LOAD_COMMANDS.include?(lc.type) }
    end

    # All segment load commands in the Mach-O.
    # @return [Array<MachO::SegmentCommand>] if the Mach-O is 32-bit
    # @return [Array<MachO::SegmentCommand64>] if the Mach-O is 64-bit
    def segments
      if magic32?
        command(:LC_SEGMENT)
      else
        command(:LC_SEGMENT_64)
      end
    end

    # The Mach-O's dylib ID, or `nil` if not a dylib.
    # @example
    #  file.dylib_id # => 'libBar.dylib'
    # @return [String, nil] the Mach-O's dylib ID
    def dylib_id
      if !dylib?
        return nil
      end

      dylib_id_cmd = command(:LC_ID_DYLIB).first

      dylib_id_cmd.name.to_s
    end

    # Changes the Mach-O's dylib ID to `new_id`. Does nothing if not a dylib.
    # @example
    #  file.dylib_id = "libFoo.dylib"
    # @param new_id [String] the dylib's new ID
    # @return [void]
    # @raise [ArgumentError] if `new_id` is not a String
    def dylib_id=(new_id)
      if !new_id.is_a?(String)
        raise ArgumentError.new("argument must be a String")
      end

      if !dylib?
        return nil
      end

      dylib_cmd = command(:LC_ID_DYLIB).first
      old_id = dylib_id

      set_name_in_dylib(dylib_cmd, old_id, new_id)
    end

    # All shared libraries linked to the Mach-O.
    # @return [Array<String>] an array of all shared libraries
    def linked_dylibs
      # Some linkers produce multiple `LC_LOAD_DYLIB` load commands for the same
      # library, but at this point we're really only interested in a list of
      # unique libraries this Mach-O file links to, thus: `uniq`. (This is also
      # for consistency with `FatFile` that merges this list across all archs.)
      dylib_load_commands.map(&:name).map(&:to_s).uniq
    end

    # Changes the shared library `old_name` to `new_name`
    # @example
    #  file.change_install_name("/usr/lib/libWhatever.dylib", "/usr/local/lib/libWhatever2.dylib")
    # @param old_name [String] the shared library's old name
    # @param new_name [String] the shared library's new name
    # @return [void]
    # @raise [MachO::DylibUnknownError] if no shared library has the old name
    def change_install_name(old_name, new_name)
      dylib_cmd = dylib_load_commands.find { |d| d.name.to_s == old_name }
      raise DylibUnknownError.new(old_name) if dylib_cmd.nil?

      set_name_in_dylib(dylib_cmd, old_name, new_name)
    end

    alias :change_dylib :change_install_name

    # All runtime paths searched by the dynamic linker for the Mach-O.
    # @return [Array<String>] an array of all runtime paths
    def rpaths
      command(:LC_RPATH).map(&:path).map(&:to_s)
    end

    # Changes the runtime path `old_path` to `new_path`
    # @example
    #  file.change_rpath("/usr/lib", "/usr/local/lib")
    # @param old_path [String] the old runtime path
    # @param new_path [String] the new runtime path
    # @return [void]
    # @raise [MachO::RpathUnknownError] if no such old runtime path exists
    # @api private
    def change_rpath(old_path, new_path)
      rpath_cmd = command(:LC_RPATH).find { |r| r.path.to_s == old_path }
      raise RpathUnknownError.new(old_path) if rpath_cmd.nil?

      set_path_in_rpath(rpath_cmd, old_path, new_path)
    end

    # All sections of the segment `segment`.
    # @param segment [MachO::SegmentCommand, MachO::SegmentCommand64] the segment being inspected
    # @return [Array<MachO::Section>] if the Mach-O is 32-bit
    # @return [Array<MachO::Section64>] if the Mach-O is 64-bit
    def sections(segment)
      sections = []

      if !segment.is_a?(SegmentCommand) && !segment.is_a?(SegmentCommand64)
        raise ArgumentError.new("not a valid segment")
      end

      if segment.nsects.zero?
        return sections
      end

      offset = segment.offset + segment.class.bytesize

      segment.nsects.times do
        if segment.is_a? SegmentCommand
          sections << Section.new_from_bin(@raw_data.slice(offset, Section.bytesize))
          offset += Section.bytesize
        else
          sections << Section64.new_from_bin(@raw_data.slice(offset, Section64.bytesize))
          offset += Section64.bytesize
        end
      end

      sections
    end

    # Write all Mach-O data to the given filename.
    # @param filename [String] the file to write to
    # @return [void]
    def write(filename)
      File.open(filename, "wb") { |f| f.write(@raw_data) }
    end

    # Write all Mach-O data to the file used to initialize the instance.
    # @return [void]
    # @raise [MachO::MachOError] if the instance was initialized without a file
    # @note Overwrites all data in the file!
    def write!
      if @filename.nil?
        raise MachOError.new("cannot write to a default file when initialized from a binary string")
      else
        File.open(@filename, "wb") { |f| f.write(@raw_data) }
      end
    end

    private

    # The file's Mach-O header structure.
    # @return [MachO::MachHeader] if the Mach-O is 32-bit
    # @return [MachO::MachHeader64] if the Mach-O is 64-bit
    # @raise [MachO::TruncatedFileError] if the file is too small to have a valid header
    # @private
    def get_mach_header
      # the smallest Mach-O header is 28 bytes
      raise TruncatedFileError.new if @raw_data.size < 28

      magic = get_and_check_magic
      mh_klass = MachO.magic32?(magic) ? MachHeader : MachHeader64
      mh = mh_klass.new_from_bin(@raw_data[0, mh_klass.bytesize])

      check_cputype(mh.cputype)
      check_cpusubtype(mh.cpusubtype)
      check_filetype(mh.filetype)

      mh
    end

    # Read just the file's magic number and check its validity.
    # @return [Fixnum] the magic
    # @raise [MachO::MagicError] if the magic is not valid Mach-O magic
    # @raise [MachO::FatBinaryError] if the magic is for a Fat file
    # @private
    def get_and_check_magic
      magic = @raw_data[0..3].unpack("N").first

      raise MagicError.new(magic) unless MachO.magic?(magic)
      raise FatBinaryError.new if MachO.fat_magic?(magic)

      magic
    end

    # Check the file's CPU type.
    # @param cputype [Fixnum] the CPU type
    # @raise [MachO::CPUTypeError] if the CPU type is unknown
    # @private
    def check_cputype(cputype)
      raise CPUTypeError.new(cputype) unless CPU_TYPES.key?(cputype)
    end

    # Check the file's CPU sub-type.
    # @param cpusubtype [Fixnum] the CPU subtype
    # @raise [MachO::CPUSubtypeError] if the CPU sub-type is unknown
    # @private
    def check_cpusubtype(cpusubtype)
      # Only check sub-type w/o capability bits (see `get_mach_header`).
      raise CPUSubtypeError.new(cpusubtype) unless CPU_SUBTYPES.key?(cpusubtype)
    end

    # Check the file's type.
    # @param filetype [Fixnum] the file type
    # @raise [MachO::FiletypeError] if the file type is unknown
    # @private
    def check_filetype(filetype)
      raise FiletypeError.new(filetype) unless MH_FILETYPES.key?(filetype)
    end

    # All load commands in the file.
    # @return [Array<MachO::LoadCommand>] an array of load commands
    # @raise [MachO::LoadCommandError] if an unknown load command is encountered
    # @private
    def get_load_commands
      offset = header.class.bytesize
      load_commands = []

      header.ncmds.times do
        cmd = @raw_data.slice(offset, 4).unpack("V").first
        cmd_sym = LOAD_COMMANDS[cmd]

        raise LoadCommandError.new(cmd) if cmd_sym.nil?

        # why do I do this? i don't like declaring constants below
        # classes, and i need them to resolve...
        klass = MachO.const_get "#{LC_STRUCTURES[cmd_sym]}"
        command = klass.new_from_bin(@raw_data, offset, @raw_data.slice(offset, klass.bytesize))

        load_commands << command
        offset += command.cmdsize
      end

      load_commands
    end

    # Updates the size of all load commands in the raw data.
    # @param size [Fixnum] the new size, in bytes
    # @return [void]
    # @private
    def set_sizeofcmds(size)
      new_size = [size].pack("V")
      @raw_data[20..23] = new_size
    end

    # Updates the `name` field in a DylibCommand.
    # @param dylib_cmd [MachO::DylibCommand] the dylib command
    # @param old_name [String] the old dylib name
    # @param new_name [String] the new dylib name
    # @return [void]
    # @private
    def set_name_in_dylib(dylib_cmd, old_name, new_name)
      set_lc_str_in_cmd(dylib_cmd, dylib_cmd.name, old_name, new_name)
    end

    # Updates the `path` field in an RpathCommand.
    # @param rpath_cmd [MachO::RpathCommand] the rpath command
    # @param old_path [String] the old runtime name
    # @param new_path [String] the new runtime name
    # @return [void]
    # @private
    def set_path_in_rpath(rpath_cmd, old_path, new_path)
      set_lc_str_in_cmd(rpath_cmd, rpath_cmd.path, old_path, new_path)
    end

    # Updates a generic LCStr field in any LoadCommand.
    # @param cmd [MachO::LoadCommand] the load command
    # @param lc_str [MachO::LoadCommand::LCStr] the load command string
    # @param old_str [String] the old string
    # @param new_str [String] the new string
    # @raise [MachO::HeaderPadError] if the new name exceeds the header pad buffer
    # @private
    def set_lc_str_in_cmd(cmd, lc_str, old_str, new_str)
      if magic32?
        cmd_round = 4
      else
        cmd_round = 8
      end

      new_sizeofcmds = header.sizeofcmds
      old_str = old_str.dup
      new_str = new_str.dup

      old_pad = MachO.round(old_str.size + 1, cmd_round) - old_str.size
      new_pad = MachO.round(new_str.size + 1, cmd_round) - new_str.size

      # pad the old and new IDs with null bytes to meet command bounds
      old_str << "\x00" * old_pad
      new_str << "\x00" * new_pad

      # calculate the new size of the cmd and sizeofcmds in MH
      new_size = cmd.class.bytesize + new_str.size
      new_sizeofcmds += new_size - cmd.cmdsize

      low_fileoff = @raw_data.size

      # calculate the low file offset (offset to first section data)
      segments.each do |seg|
        sections(seg).each do |sect|
          next if sect.size == 0
          next if sect.flag?(:S_ZEROFILL)
          next if sect.flag?(:S_THREAD_LOCAL_ZEROFILL)
          next unless sect.offset < low_fileoff

          low_fileoff = sect.offset
        end
      end

      if new_sizeofcmds + header.class.bytesize > low_fileoff
        raise HeaderPadError.new(@filename)
      end

      # update sizeofcmds in mach_header
      set_sizeofcmds(new_sizeofcmds)

      # update cmdsize in the cmd
      @raw_data[cmd.offset + 4, 4] = [new_size].pack("V")

      # delete the old str
      @raw_data.slice!(cmd.offset + lc_str.to_i...cmd.offset + cmd.class.bytesize + old_str.size)

      # insert the new str
      @raw_data.insert(cmd.offset + lc_str.to_i, new_str)

      # pad/unpad after new_sizeofcmds until offsets are corrected
      null_pad = old_str.size - new_str.size

      if null_pad < 0
        @raw_data.slice!(new_sizeofcmds + header.class.bytesize, null_pad.abs)
      else
        @raw_data.insert(new_sizeofcmds + header.class.bytesize, "\x00" * null_pad)
      end

      # synchronize fields with the raw data
      @header = get_mach_header
      @load_commands = get_load_commands
    end
  end
end
