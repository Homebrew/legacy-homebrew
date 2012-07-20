require 'formula'

class Atk < Formula
  homepage 'http://library.gnome.org/devel/atk/'
  url 'http://ftp.gnome.org/pub/gnome/sources/atk/2.5/atk-2.5.4.tar.xz'
  sha256 'af6d6d8ec4543f338bf2476974de69891b7419913dd1cf4a94d53696bcc14aab'

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
