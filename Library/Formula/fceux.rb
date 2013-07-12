require 'formula'

class Fceux < Formula
  homepage 'http://fceux.com'
  url 'http://downloads.sourceforge.net/project/fceultra/Source%20Code/2.2.1%20src/fceux-2.2.1.1.src.tar.gz'
  sha1 'a9e7babf7a883bfa17ee7cc4a1989382dfbced65'

  option 'no-gtk', "Build without Gtk+ support"

  depends_on 'scons' => :build
  depends_on 'sdl'
  depends_on 'libzip'
  depends_on 'gtk+' unless build.include? "no-gtk"
  depends_on 'lua'
  depends_on :x11

  def install
    # Propagate PKG_CONFIG_PATH to Scons environment
    pkg_config_path = "#{MacOS::X11.lib}/pkgconfig:#{ENV['PKG_CONFIG_PATH']}"
    inreplace "Sconstruct",
      "env.ParseConfig('pkg-config --cflags --libs gtk+-2.0')",
      "env.ParseConfig('PKG_CONFIG_PATH=#{pkg_config_path} pkg-config --cflags --libs gtk+-2.0')"

    inreplace "src/drivers/sdl/SConscript",
      "env.ParseConfig('pkg-config --cflags --libs x11')",
      "env.ParseConfig('PKG_CONFIG_PATH=#{pkg_config_path} pkg-config --cflags --libs x11')"

    if build.include? "no-gtk"
      inreplace "SConstruct",
        "BoolVariable('GTK', 'Enable GTK2 GUI (SDL only)', 1),",
        "BoolVariable('GTK', 'Enable GTK2 GUI (SDL only)', 0),"
    end

    system "scons"
    bin.install 'src/fceux'
  end
end
