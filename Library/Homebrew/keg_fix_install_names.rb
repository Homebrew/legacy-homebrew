class Keg < Pathname
  PREFIX_PLACEHOLDER = "@@HOMEBREW_PREFIX@@".freeze
  CELLAR_PLACEHOLDER = "@@HOMEBREW_CELLAR@@".freeze

  def fix_install_names options={}
    mach_o_files.each do |file|
      file.ensure_writable do
        change_dylib_id(dylib_id_for(file, options), file) if file.dylib?

        each_install_name_for(file) do |bad_name|
          # Don't fix absolute paths unless they are rooted in the build directory
          next if bad_name.start_with? '/' and not bad_name.start_with? HOMEBREW_TEMP.to_s

          new_name = fixed_name(file, bad_name)
          change_install_name(bad_name, new_name, file) unless new_name == bad_name
        end
      end
    end
  end

  def relocate_install_names old_prefix, new_prefix, old_cellar, new_cellar, options={}
    mach_o_files.each do |file|
      file.ensure_writable do
        if file.dylib?
          id = dylib_id_for(file, options).sub(old_prefix, new_prefix)
          change_dylib_id(id, file)
        end

        each_install_name_for(file) do |old_name|
          if old_name.start_with? old_cellar
            new_name = old_name.sub(old_cellar, new_cellar)
          elsif old_name.start_with? old_prefix
            new_name = old_name.sub(old_prefix, new_prefix)
          end

          change_install_name(old_name, new_name, file) if new_name
        end
      end
    end

    files = pkgconfig_files | libtool_files | script_files

    files.group_by { |f| f.stat.ino }.each_value do |first, *rest|
      s = first.open("rb", &:read)
      changed = s.gsub!(old_cellar, new_cellar)
      changed = s.gsub!(old_prefix, new_prefix) || changed

      begin
        first.atomic_write(s)
      rescue Errno::EACCES
        first.ensure_writable do
          first.open("wb") { |f| f.write(s) }
        end
      else
        rest.each { |file| FileUtils.ln(first, file, :force => true) }
      end if changed
    end
  end

  def change_dylib_id(id, file)
    puts "Changing dylib ID in #{file} to #{id}" if ARGV.debug?
    install_name_tool("-id", id, file)
  end

  def change_install_name(old, new, file)
    puts "Changing install name in #{file} from #{old} to #{new}" if ARGV.debug?
    install_name_tool("-change", old, new, file)
  end

  # Detects the C++ dynamic libraries in place, scanning the dynamic links
  # of the files within the keg. This searches only libs contained within
  # lib/, and ignores binaries and other mach-o objects
  # Note that this doesn't attempt to distinguish between libstdc++ versions,
  # for instance between Apple libstdc++ and GNU libstdc++
  def detect_cxx_stdlibs(opts={:skip_executables => false})
    results = Set.new

    mach_o_files.each do |file|
      next if file.mach_o_executable? && opts[:skip_executables]
      dylibs = file.dynamically_linked_libraries
      results << :libcxx unless dylibs.grep(/libc\+\+.+\.dylib/).empty?
      results << :libstdcxx unless dylibs.grep(/libstdc\+\+.+\.dylib/).empty?
    end

    results.to_a
  end

  def each_unique_file_matching string
    IO.popen("/usr/bin/fgrep -lr '#{string}' '#{self}' 2>/dev/null", "rb") do |io|
      hardlinks = Set.new

      until io.eof?
        file = Pathname.new(io.readline.chomp)
        next if file.symlink?
        yield file if hardlinks.add? file.stat.ino
      end
    end
  end

  def install_name_tool(*args)
    system(MacOS.locate("install_name_tool"), *args)
  end

  # If file is a dylib or bundle itself, look for the dylib named by
  # bad_name relative to the lib directory, so that we can skip the more
  # expensive recursive search if possible.
  def fixed_name(file, bad_name)
    if bad_name.start_with? PREFIX_PLACEHOLDER
      bad_name.sub(PREFIX_PLACEHOLDER, HOMEBREW_PREFIX.to_s)
    elsif bad_name.start_with? CELLAR_PLACEHOLDER
      bad_name.sub(CELLAR_PLACEHOLDER, HOMEBREW_CELLAR.to_s)
    elsif (file.dylib? || file.mach_o_bundle?) && (file.parent + bad_name).exist?
      "@loader_path/#{bad_name}"
    elsif file.mach_o_executable? && (lib + bad_name).exist?
      "#{lib}/#{bad_name}"
    elsif (abs_name = find_dylib(Pathname.new(bad_name).basename)) && abs_name.exist?
      abs_name.to_s
    else
      opoo "Could not fix #{bad_name} in #{file}"
      bad_name
    end
  end

  def lib; join 'lib' end

  def each_install_name_for file, &block
    dylibs = file.dynamically_linked_libraries
    dylibs.reject! { |fn| fn =~ /^@(loader_|executable_|r)path/ }
    dylibs.each(&block)
  end

  def dylib_id_for file, options={}
    # The new dylib ID should have the same basename as the old dylib ID, not
    # the basename of the file itself.
    basename = File.basename(file.dylib_id)
    relative_dirname = file.dirname.relative_path_from(self)
    shortpath = HOMEBREW_PREFIX.join(relative_dirname, basename)

    if shortpath.exist? and not options[:keg_only]
      shortpath.to_s
    else
      "#{HOMEBREW_PREFIX}/opt/#{fname}/#{relative_dirname}/#{basename}"
    end
  end

  def find_dylib name
    lib.find { |pn| break pn if pn.basename == name }
  end

  def mach_o_files
    mach_o_files = []
    dirs = %w{bin lib Frameworks}
    dirs.map! { |dir| join(dir) }
    dirs.reject! { |dir| not dir.directory? }

    dirs.each do |dir|
      dir.find do |pn|
        next if pn.symlink? or pn.directory?
        mach_o_files << pn if pn.dylib? or pn.mach_o_bundle? or pn.mach_o_executable?
      end
    end

    mach_o_files
  end

  def script_files
    script_files = []

    # find all files with shebangs
    find do |pn|
      next if pn.symlink? or pn.directory?
      script_files << pn if pn.text_executable?
    end

    script_files
  end

  def pkgconfig_files
    pkgconfig_files = []

    %w[lib share].each do |dir|
      pcdir = join(dir, "pkgconfig")

      pcdir.find do |pn|
        next if pn.symlink? or pn.directory? or pn.extname != '.pc'
        pkgconfig_files << pn
      end if pcdir.directory?
    end

    pkgconfig_files
  end

  def libtool_files
    libtool_files = []

    # find .la files, which are stored in lib/
    lib.find do |pn|
      next if pn.symlink? or pn.directory? or pn.extname != '.la'
      libtool_files << pn
    end if lib.directory?
    libtool_files
  end
end
