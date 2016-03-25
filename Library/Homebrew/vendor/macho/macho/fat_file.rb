module MachO
  # Represents a "Fat" file, which contains a header, a listing of available
  # architectures, and one or more Mach-O binaries.
  # @see https://en.wikipedia.org/wiki/Mach-O#Multi-architecture_binaries
  # @see MachO::MachOFile
  class FatFile
    # @return [MachO::FatHeader] the file's header
    attr_reader :header

    # @return [Array<MachO::FatArch>] an array of fat architectures
    attr_reader :fat_archs

    # @return [Array<MachO::MachOFile>] an array of Mach-O binaries
    attr_reader :machos

    # Creates a new FatFile instance from a binary string.
    # @param bin [String] a binary string containing raw Mach-O data
    # @return [MachO::FatFile] a new FatFile
    def self.new_from_bin(bin)
      instance = allocate
      instance.initialize_from_bin(bin)

      instance
    end

    # Creates a new FatFile from the given filename.
    # @param filename [String] the fat file to load from
    # @raise [ArgumentError] if the given filename does not exist
    def initialize(filename)
      raise ArgumentError.new("#{filetype}: no such file") unless File.exist?(filename)

      @filename = filename
      @raw_data = open(@filename, "rb") { |f| f.read }
      @header = get_fat_header
      @fat_archs = get_fat_archs
      @machos = get_machos
    end

    # @api private
    def initialize_from_bin(bin)
      @filename = nil
      @raw_data = bin
      @header = get_fat_header
      @fat_archs = get_fat_archs
      @machos = get_machos
    end

    # The file's raw fat data.
    # @return [String] the raw fat data
    def serialize
      @raw_data
    end

    # @return [Boolean] true if the file is of type `MH_OBJECT`, false otherwise
    def object?
      machos.first.object?
    end

    # @return [Boolean] true if the file is of type `MH_EXECUTE`, false otherwise
    def executable?
      machos.first.executable?
    end

    # @return [Boolean] true if the file is of type `MH_FVMLIB`, false otherwise
    def fvmlib?
      machos.first.fvmlib?
    end

    # @return [Boolean] true if the file is of type `MH_CORE`, false otherwise
    def core?
      machos.first.core?
    end

    # @return [Boolean] true if the file is of type `MH_PRELOAD`, false otherwise
    def preload?
      machos.first.preload?
    end

    # @return [Boolean] true if the file is of type `MH_DYLIB`, false otherwise
    def dylib?
      machos.first.dylib?
    end

    # @return [Boolean] true if the file is of type `MH_DYLINKER`, false otherwise
    def dylinker?
      machos.first.dylinker?
    end

    # @return [Boolean] true if the file is of type `MH_BUNDLE`, false otherwise
    def bundle?
      machos.first.bundle?
    end

    # @return [Boolean] true if the file is of type `MH_DSYM`, false otherwise
    def dsym?
      machos.first.dsym?
    end

    # @return [Boolean] true if the file is of type `MH_KEXT_BUNDLE`, false otherwise
    def kext?
      machos.first.kext?
    end

    # @return [Fixnum] the file's magic number
    def magic
      header.magic
    end

    # @return [String] a string representation of the file's magic number
    def magic_string
      MH_MAGICS[magic]
    end

    # The file's type. Assumed to be the same for every Mach-O within.
    # @return [String] the filetype
    def filetype
      machos.first.filetype
    end

    # The file's dylib ID. If the file is not a dylib, returns `nil`.
    # @example
    #  file.dylib_id # => 'libBar.dylib'
    # @return [String, nil] the file's dylib ID
    def dylib_id
      machos.first.dylib_id
    end

    # Changes the file's dylib ID to `new_id`. If the file is not a dylib, does nothing.
    # @example
    #  file.dylib_id = 'libFoo.dylib'
    # @param new_id [String] the new dylib ID
    # @return [void]
    # @raise [ArgumentError] if `new_id` is not a String
    def dylib_id=(new_id)
      if !new_id.is_a?(String)
        raise ArgumentError.new("argument must be a String")
      end

      if !machos.all?(&:dylib?)
        return nil
      end

      machos.each do |macho|
        macho.dylib_id = new_id
      end

      synchronize_raw_data
    end

    # All shared libraries linked to the file's Mach-Os.
    # @return [Array<String>] an array of all shared libraries
    def linked_dylibs
      # Individual architectures in a fat binary can link to different subsets
      # of libraries, but at this point we want to have the full picture, i.e.
      # the union of all libraries used by all architectures.
      machos.map(&:linked_dylibs).flatten.uniq
    end

    # Changes all dependent shared library install names from `old_name` to `new_name`.
    # In a fat file, this changes install names in all internal Mach-Os.
    # @example
    #  file.change_install_name('/usr/lib/libFoo.dylib', '/usr/lib/libBar.dylib')
    # @param old_name [String] the shared library name being changed
    # @param new_name [String] the new name
    # @todo incomplete
    def change_install_name(old_name, new_name)
      machos.each do |macho|
        macho.change_install_name(old_name, new_name)
      end

      synchronize_raw_data
    end

    alias :change_dylib :change_install_name

    # Extract a Mach-O with the given CPU type from the file.
    # @example
    #  file.extract("CPU_TYPE_I386") # => MachO::MachOFile
    # @param cputype [String] the CPU type of the Mach-O being extracted
    # @return [MachO::MachOFile, nil] the extracted Mach-O or nil if no Mach-O has the given CPU type
    def extract(cputype)
      machos.select { |macho| macho.cputype == cputype }.first
    end

    # Write all (fat) data to the given filename.
    # @param filename [String] the file to write to
    def write(filename)
      File.open(filename, "wb") { |f| f.write(@raw_data) }
    end

    # Write all (fat) data to the file used to initialize the instance.
    # @return [void]
    # @raise [MachO::MachOError] if the instance was initialized without a file
    # @note Overwrites all data in the file!
    def write!
      if filename.nil?
        raise MachOError.new("cannot write to a default file when initialized from a binary string")
      else
        File.open(@filename, "wb") { |f| f.write(@raw_data) }
      end
    end

    private

    # Obtain the fat header from raw file data.
    # @return [MachO::FatHeader] the fat header
    # @raise [MachO::TruncatedFileError] if the file is too small to have a valid header
    # @raise [MachO::MagicError] if the magic is not valid Mach-O magic
    # @raise [MachO::MachOBinaryError] if the magic is for a non-fat Mach-O file
    # @raise [MachO::JavaClassFileError] if the file is a Java classfile
    # @private
    def get_fat_header
      # the smallest fat Mach-O header is 8 bytes
      raise TruncatedFileError.new if @raw_data.size < 8

      fh = FatHeader.new_from_bin(@raw_data[0, FatHeader.bytesize])

      raise MagicError.new(fh.magic) unless MachO.magic?(fh.magic)
      raise MachOBinaryError.new unless MachO.fat_magic?(fh.magic)

      # Rationale: Java classfiles have the same magic as big-endian fat
      # Mach-Os. Classfiles encode their version at the same offset as
      # `nfat_arch` and the lowest version number is 43, so we error out
      # if a file claims to have over 30 internal architectures. It's
      # technically possible for a fat Mach-O to have over 30 architectures,
      # but this is extremely unlikely and in practice distinguishes the two
      # formats.
      raise JavaClassFileError.new if fh.nfat_arch > 30

      fh
    end

    # Obtain an array of fat architectures from raw file data.
    # @return [Array<MachO::FatArch>] an array of fat architectures
    # @private
    def get_fat_archs
      archs = []

      fa_off = FatHeader.bytesize
      fa_len = FatArch.bytesize
      header.nfat_arch.times do |i|
        archs << FatArch.new_from_bin(@raw_data[fa_off + (fa_len * i), fa_len])
      end

      archs
    end

    # Obtain an array of Mach-O blobs from raw file data.
    # @return [Array<MachO::MachOFile>] an array of Mach-Os
    # @private
    def get_machos
      machos = []

      fat_archs.each do |arch|
        machos << MachOFile.new_from_bin(@raw_data[arch.offset, arch.size])
      end

      machos
    end

    # @todo this needs to be redesigned. arch[:offset] and arch[:size] are
    # already out-of-date, and the header needs to be synchronized as well.
    # @private
    def synchronize_raw_data
      machos.each_with_index do |macho, i|
        arch = fat_archs[i]

        @raw_data[arch.offset, arch.size] = macho.serialize
      end
    end
  end
end
