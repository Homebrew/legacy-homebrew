require 'formula'

class GobjectIntrospection <Formula
  url 'http://ftp.gnome.org/pub/GNOME/sources/gobject-introspection/0.9/gobject-introspection-0.9.12.tar.bz2'
  homepage 'http://live.gnome.org/GObjectIntrospection'
  sha256 '9c0060d66d14a060057a1fc005be73675a1b8a00d4968ce8e78ff2d6b9f84e81'

  depends_on 'pkg-config' => :build
  depends_on 'libffi'
  depends_on 'glib'

  def install
    ENV['FFI_CFLAGS'] = '-I/usr/include/ffi'
    ENV['FFI_LIBS'] = '-L/usr/lib -lffi'
    # "cairo not found; pass --disable-tests or install cairo"
    system "./configure", "--prefix=#{prefix}", "--disable-tests"
    system "make install"
  end
end
