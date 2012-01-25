require 'formula'

class GobjectIntrospection < Formula
  url 'http://ftp.gnome.org/pub/gnome/sources/gobject-introspection/1.31/gobject-introspection-1.31.10.tar.xz'
  homepage 'http://live.gnome.org/GObjectIntrospection'
  md5 'f71e80054048546d282af5f205a08a14'
  version '1.31.10'

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
