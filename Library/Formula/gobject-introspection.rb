require 'formula'

class GobjectIntrospection < Formula
  url 'http://ftp.gnome.org/pub/GNOME/sources/gobject-introspection/0.10/gobject-introspection-0.10.8.tar.bz2'
  homepage 'http://live.gnome.org/GObjectIntrospection'
  md5 'b5da58a5327d13b4d1e08b8e42b2456d'

  depends_on 'glib'
  depends_on 'libffi'

  def options
    [
      ["--universal", "Builds a universal binary"]
    ]
  end

  def install
    ENV.universal_binary if ARGV.build_universal?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
