require 'formula'

class Atk < Formula
  homepage 'http://library.gnome.org/devel/atk/'
  url 'http://ftp.gnome.org/pub/gnome/sources/atk/2.10/atk-2.10.0.tar.xz'
  sha256 '636917a5036bc851d8491194645d284798ec118919a828be5e713b6ecc5b50b0'

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'glib'
  depends_on 'gobject-introspection'

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-introspection=yes"
    system "make"
    system "make install"
  end
end
