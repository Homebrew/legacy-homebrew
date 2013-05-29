require 'formula'

class Py2gobject3 < Formula
  homepage 'http://live.gnome.org/PyGObject'
  url 'http://ftp.gnome.org/pub/GNOME/sources/pygobject/3.0/pygobject-3.0.4.tar.xz'
  sha1 '72df1cdd6e34d52ada6e32f1bbd7f36f4be67512'

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'glib'
  depends_on 'gobject-introspection'
  depends_on 'py2cairo'

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
