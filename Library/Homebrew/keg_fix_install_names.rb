class Keg
  def fix_install_names
    dylibs.each do |dylib|
      bad_install_names_for dylib do |id, bad_names|
        dylib.ensure_writable do
          system "install_name_tool", "-id", id, dylib
          bad_names.each do |bad_name|
            # we should be more careful here, check the path we point to exists etc.
            system "install_name_tool", "-change", bad_name, "@loader_path/#{bad_name}", dylib
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
    install_names.reject!{ |fn| fn.start_with? '/' }

    unless install_names.empty? and id == dylib # avoid the work if possible
      yield dylib, install_names
    end
  end

  def dylibs
    if (lib = join 'lib').directory?
      lib.children.select{ |pn| pn.extname == '.dylib' and not pn.symlink? }
    else
      []
    end
  end
end
