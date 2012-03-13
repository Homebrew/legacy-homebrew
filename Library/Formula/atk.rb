require 'formula'

class Atk < Formula
  homepage 'http://library.gnome.org/devel/atk/'
  url 'http://ftp.gnome.org/pub/gnome/sources/atk/2.2/atk-2.2.0.tar.bz2'
  sha256 'd201e3f5808aef0b1aec2277bfa61074f68863e405428adb57a73aab5c838450'

  depends_on 'pkg-config' => :build
  depends_on 'glib'

  def options
    [["--universal", "Builds a universal binary"]]
  end

  def install
    ENV.universal_binary if ARGV.build_universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-introspection=no"
    system "make"
    system "make install"
  end
end
