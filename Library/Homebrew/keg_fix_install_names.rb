class Keg
  def fix_install_names
    dylibs.each do |dylib|
      bad_install_names_for dylib do |id, bad_names|
        dylib.ensure_writable do
          system "install_name_tool", "-id", id, dylib
          bad_names.each do |bad_name|
            new_name = bad_name
            new_name = Pathname.new(bad_name).basename unless (dylib.parent + new_name).exist?
            # this fixes some problems, maybe not all. opencv seems to have badnames of the type
            # "lib/libblah.dylib"
            if (dylib.parent + new_name).exist?
              system "install_name_tool", "-change", bad_name, "@loader_path/#{new_name}", dylib
            else
              opoo "Could not fix install names for #{dylib}"
            end
          end
        end
      end
    end
  end

  private

  OTOOL_RX = /\t(.*) \(compatibility version (\d+\.)*\d+, current version (\d+\.)*\d+\)/

  def bad_install_names_for dylib
    dylib = dylib.to_s

    ENV['HOMEBREW_DYLIB'] = dylib # solves all shell escaping problems
    install_names = `otool -L "$HOMEBREW_DYLIB"`.split "\n"

    install_names.shift # first line is fluff
    install_names.map!{ |s| OTOOL_RX =~ s && $1 }
    id = install_names.shift
    install_names.compact!
    install_names.reject!{ |fn| fn =~ /^@(loader|executable)_path/ }
    install_names.reject!{ |fn| fn[0,1] == '/' }

    # the shortpath ensures that library upgrades don’t break installed tools
    shortpath = HOMEBREW_PREFIX + Pathname.new(dylib).relative_path_from(self)
    id = if shortpath.exist? then shortpath else dylib end

    yield id, install_names
  end

  def dylibs
    require 'find'
    dylibs = []
    if (lib = join 'lib').directory?
      lib.find do |pn|
        next if pn.symlink? or pn.directory?
        dylibs << pn if pn.extname == '.dylib'
      end
    end
    dylibs
  end
end
