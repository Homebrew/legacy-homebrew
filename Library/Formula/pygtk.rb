require 'formula'

class Pygtk < Formula
  url 'http://ftp.acc.umu.se/pub/GNOME/sources/pygtk/2.24/pygtk-2.24.0.tar.bz2'
  homepage 'http://www.pygtk.org/'
  md5 'a1051d5794fd7696d3c1af6422d17a49'

  depends_on 'glib'
  depends_on 'native-gtk+'
  depends_on 'pygobject'
  depends_on 'py2cairo'

  def install
    ENV.append 'CFLAGS', '-ObjC'
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
