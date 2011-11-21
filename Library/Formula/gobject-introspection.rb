require 'formula'

class GobjectIntrospection < Formula
  url 'http://ftp.gnome.org/pub/GNOME/sources/gobject-introspection/0.10/gobject-introspection-0.10.8.tar.bz2'
  homepage 'http://live.gnome.org/GObjectIntrospection'
  md5 'b5da58a5327d13b4d1e08b8e42b2456d'

  depends_on 'glib'
  depends_on 'libffi'

  def installg
    ffi_prefix = `brew --prefix libffi`.chomp

    ENV['PKG_CONFIG_PATH'] = "#{ffi_prefix}/lib/pkgconfig:#{ENV['PKG_CONFIG_PATH']}"

    system "./configure --prefix=#{prefix}"
    system "make install"
  end
end
