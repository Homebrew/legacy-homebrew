class Keg
  def fix_install_names
    mach_o_files.each do |file|
      bad_install_names_for file do |id, bad_names|
        file.ensure_writable do
          system MacOS.locate("install_name_tool"), "-id", id, file if file.dylib?

          bad_names.each do |bad_name|
            new_name = bad_name
            new_name = Pathname.new(bad_name).basename unless (file.parent + new_name).exist?

            # First check to see if the dylib is present in the current
            # directory, so we can skip the more expensive search.
            if (file.parent + new_name).exist?
              system MacOS.locate("install_name_tool"), "-change", bad_name, "@loader_path/#{new_name}", file
            else
              # Otherwise, try and locate the appropriate dylib by walking
              # the entire 'lib' tree recursively.
              abs_name = (self+'lib').find do |pn|
                break pn if pn.basename == Pathname.new(new_name)
              end

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

  def bad_install_names_for file
    ENV['HOMEBREW_MACH_O_FILE'] = file.to_s # solves all shell escaping problems
    install_names = `#{MacOS.locate("otool")} -L "$HOMEBREW_MACH_O_FILE"`.split "\n"

    install_names.shift # first line is fluff
    install_names.map!{ |s| OTOOL_RX =~ s && $1 }

    # Bundles don't have an ID
    id = install_names.shift unless file.mach_o_bundle?

    install_names.compact!
    install_names.reject!{ |fn| fn =~ /^@(loader|executable)_path/ }

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

  def mach_o_files
    mach_o_files = []
    if (lib = join 'lib').directory?
      lib.find do |pn|
        next if pn.symlink? or pn.directory?
        mach_o_files << pn if pn.dylib? or pn.mach_o_bundle?
      end
    end
    mach_o_files
  end
end
