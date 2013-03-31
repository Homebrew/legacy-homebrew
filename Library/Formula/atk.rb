require 'formula'

class Atk < Formula
  homepage 'http://library.gnome.org/devel/atk/'
  url 'http://ftp.gnome.org/pub/gnome/sources/atk/2.8/atk-2.8.0.tar.xz'
  sha256 'b22519176226f3e07cf6d932b77852e6b6be4780977770704b32d0f4e0686df4'

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'glib'

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-introspection=no"
    system "make"
    system "make install"
  end
end
