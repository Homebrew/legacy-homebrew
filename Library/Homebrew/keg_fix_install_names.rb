class Keg
  def fix_install_names
    mach_o_files.each do |file|
      bad_install_names_for file do |id, bad_names|
        file.ensure_writable do
          system MacOS.locate("install_name_tool"), "-id", id, file if file.dylib?

          bad_names.each do |bad_name|
            # If file is a dylib or bundle itself, look for the dylib named by
            # bad_name relative to the lib directory, so that we can skip the more
            # expensive recursive search if possible.
            if file.dylib? or file.mach_o_bundle? and (file.parent + bad_name).exist?
              system MacOS.locate("install_name_tool"), "-change", bad_name, "@loader_path/#{bad_name}", file
            elsif file.mach_o_executable? and (lib/bad_name).exist?
              system MacOS.locate("install_name_tool"), "-change", bad_name, "#{lib}/#{bad_name}", file
            else
              # Otherwise, try and locate the dylib by walking the entire
              # lib tree recursively.
              abs_name = find_dylib(Pathname.new(bad_name).basename)

              if abs_name and abs_name.exist?
                system MacOS.locate("install_name_tool"), "-change", bad_name, abs_name, file
              else
                opoo "Could not fix install names for #{file}"
              end
            end
          end
        end
      end
    end
  end

  private

  OTOOL_RX = /\t(.*) \(compatibility version (\d+\.)*\d+, current version (\d+\.)*\d+\)/

  def lib; join 'lib' end

  def bad_install_names_for file
    ENV['HOMEBREW_MACH_O_FILE'] = file.to_s # solves all shell escaping problems
    install_names = `#{MacOS.locate("otool")} -L "$HOMEBREW_MACH_O_FILE"`.split "\n"

    install_names.shift # first line is fluff
    install_names.map!{ |s| OTOOL_RX =~ s && $1 }

    # Bundles and executables do not have an ID
    id = install_names.shift if file.dylib?

    install_names.compact!
    install_names.reject!{ |fn| fn =~ /^@(loader_|executable_|r)path/ }

    # Don't fix absolute paths unless they are rooted in the build directory
    install_names.reject! do |fn|
      tmp = ENV['HOMEBREW_TEMP'] ? Regexp.escape(ENV['HOMEBREW_TEMP']) : '/tmp'
      fn[0,1] == '/' and not %r[^#{tmp}] === fn
    end

    # the shortpath ensures that library upgrades don’t break installed tools
    relative_path = Pathname.new(file).relative_path_from(self)
    shortpath = HOMEBREW_PREFIX.join(relative_path)
    id = if shortpath.exist?
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
