class Keg
  PREFIX_PLACEHOLDER = "@@HOMEBREW_PREFIX@@".freeze
  CELLAR_PLACEHOLDER = "@@HOMEBREW_CELLAR@@".freeze

  def fix_install_names options={}
    mach_o_files.each do |file|
      file.ensure_writable do
        change_dylib_id(dylib_id_for(file, options), file) if file.dylib?

        install_names_for(file) do |bad_names|
          bad_names.each do |bad_name|
            new_name = fixed_name(file, bad_name)
            unless new_name == bad_name
              change_install_name(bad_name, new_name, file)
            end
          end
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

        install_names_for(file, relocate_reject_proc(old_cellar)) do |old_cellar_names|
          old_cellar_names.each do |old_cellar_name|
            new_cellar_name = old_cellar_name.sub(old_cellar, new_cellar)
            change_install_name(old_cellar_name, new_cellar_name, file)
          end
        end

        install_names_for(file, relocate_reject_proc(old_prefix)) do |old_prefix_names|
          old_prefix_names.each do |old_prefix_name|
            new_prefix_name = old_prefix_name.sub(old_prefix, new_prefix)
            change_install_name(old_prefix_name, new_prefix_name, file)
          end
        end
      end
    end

    (pkgconfig_files | libtool_files).each do |file|
      file.ensure_writable do
        file.open('rb') do |f|
          s = f.read
          s.gsub!(old_cellar, new_cellar)
          s.gsub!(old_prefix, new_prefix)
          f.reopen(file, 'wb')
          f.write(s)
        end
      end
    end
  end

  def change_dylib_id(id, file)
    install_name_tool("-id", id, file)
  end

  def change_install_name(old, new, file)
    install_name_tool("-change", old, new, file)
  end

  # Detects the C++ dynamic libraries in place, scanning the dynamic links
  # of the files within the keg. This searches only libs contained within
  # lib/, and ignores binaries and other mach-o objects
  # Note that this doesn't attempt to distinguish between libstdc++ versions,
  # for instance between Apple libstdc++ and GNU libstdc++
  def detect_cxx_stdlibs
    results = Set.new

    mach_o_files.each do |file|
      dylibs = file.dynamically_linked_libraries
      results << :libcxx unless dylibs.grep(/libc\+\+.+\.dylib/).empty?
      results << :libstdcxx unless dylibs.grep(/libstdc\+\+.+\.dylib/).empty?
    end

    results.to_a
  end

  private

  OTOOL_RX = /\t(.*) \(compatibility version (\d+\.)*\d+, current version (\d+\.)*\d+\)/

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

  def default_reject_proc
    Proc.new do |fn|
      # Don't fix absolute paths unless they are rooted in the build directory
      tmp = ENV['HOMEBREW_TEMP'] ? Regexp.escape(ENV['HOMEBREW_TEMP']) : '/tmp'
      fn[0,1] == '/' and not %r[^#{tmp}] === fn
    end
  end

  def relocate_reject_proc(path)
    Proc.new { |fn| not fn.start_with?(path) }
  end

  def install_names_for file, reject_proc=default_reject_proc
    ENV['HOMEBREW_MACH_O_FILE'] = file.to_s # solves all shell escaping problems
    install_names = `#{MacOS.locate("otool")} -L "$HOMEBREW_MACH_O_FILE"`.split "\n"

    install_names.shift # first line is fluff
    install_names.map!{ |s| OTOOL_RX =~ s && $1 }

    # For dylibs, the next line is the ID
    install_names.shift if file.dylib?

    install_names.compact!
    install_names.reject!{ |fn| fn =~ /^@(loader_|executable_|r)path/ }
    install_names.reject!{ |fn| reject_proc.call(fn) }

    yield install_names
  end

  def dylib_id_for file, options={}
    # the shortpath ensures that library upgrades don’t break installed tools
    relative_path = Pathname.new(file).relative_path_from(self)
    shortpath = HOMEBREW_PREFIX.join(relative_path)

    if shortpath.exist? and not options[:keg_only]
      shortpath
    else
      "#{HOMEBREW_PREFIX}/opt/#{fname}/#{relative_path}"
    end
  end

  def find_dylib name
    lib.find { |pn| break pn if pn.basename == Pathname.new(name) }
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

  def pkgconfig_files
    pkgconfig_files = []

    # find .pc files, which are stored in lib/pkgconfig
    pc_dir = self/'lib/pkgconfig'
    if pc_dir.directory?
      pc_dir.find do |pn|
        next if pn.symlink? or pn.directory? or pn.extname != '.pc'
        pkgconfig_files << pn
      end
    end

    # find name-config scripts, which can be all over the keg
    Pathname.new(self).find do |pn|
      next if pn.symlink? or pn.directory?
      pkgconfig_files << pn if pn.basename.to_s.end_with? '-config' and pn.text_executable?
    end
    pkgconfig_files
  end

  def libtool_files
    libtool_files = []

    # find .la files, which are stored in lib/
    lib.find do |pn|
      next if pn.symlink? or pn.directory? or pn.extname != '.la'
      libtool_files << pn
    end
    libtool_files
  end
end
