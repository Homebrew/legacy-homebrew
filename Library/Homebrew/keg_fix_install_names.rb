class Keg
  def fix_install_names options={}
    mach_o_files.each do |file|
      install_names_for(file, options) do |id, bad_names|
        file.ensure_writable do
          install_name_tool("-id", id, file) if file.dylib?

          bad_names.each do |bad_name|
            new_name = fixed_name(file, bad_name)
            unless new_name == bad_name
              install_name_tool("-change", bad_name, new_name, file)
            end
          end
        end
      end
    end
  end

  def relocate_install_names old_prefix, new_prefix, old_cellar, new_cellar, options={}
    mach_o_files.each do |file|
      install_names_for(file, options, relocate_reject_proc(old_prefix)) do |id, old_prefix_names|
        file.ensure_writable do
          new_prefix_id = id.to_s.gsub old_prefix, new_prefix
          install_name_tool("-id", new_prefix_id, file) if file.dylib?

          old_prefix_names.each do |old_prefix_name|
            new_prefix_name = old_prefix_name.to_s.gsub old_prefix, new_prefix
            install_name_tool("-change", old_prefix_name, new_prefix_name, file)
          end
        end
      end

      install_names_for(file, options, relocate_reject_proc(old_cellar)) do |id, old_cellar_names|
        file.ensure_writable do
          old_cellar_names.each do |old_cellar_name|
            new_cellar_name = old_cellar_name.to_s.gsub old_cellar, new_cellar
            install_name_tool("-change", old_cellar_name, new_cellar_name, file)
          end
        end
      end
    end
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
    if (file.dylib? || file.mach_o_bundle?) && (file.parent + bad_name).exist?
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

  def install_names_for file, options, reject_proc=default_reject_proc
    ENV['HOMEBREW_MACH_O_FILE'] = file.to_s # solves all shell escaping problems
    install_names = `#{MacOS.locate("otool")} -L "$HOMEBREW_MACH_O_FILE"`.split "\n"

    install_names.shift # first line is fluff
    install_names.map!{ |s| OTOOL_RX =~ s && $1 }

    # Bundles and executables do not have an ID
    id = install_names.shift if file.dylib?

    install_names.compact!
    install_names.reject!{ |fn| fn =~ /^@(loader_|executable_|r)path/ }
    install_names.reject!{ |fn| reject_proc.call(fn) }

    # the shortpath ensures that library upgrades don’t break installed tools
    relative_path = Pathname.new(file).relative_path_from(self)
    shortpath = HOMEBREW_PREFIX.join(relative_path)
    id = if shortpath.exist? and not options[:keg_only]
      shortpath
    else
      "#{HOMEBREW_PREFIX}/opt/#{fname}/#{relative_path}"
    end

    yield id, install_names
  end

  def find_dylib name
    (join 'lib').find do |pn|
      break pn if pn.basename == Pathname.new(name)
    end
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
end
