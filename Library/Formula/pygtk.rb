require 'formula'

class Pygtk < Formula
  url 'http://ftp.gnome.org/pub/GNOME/sources/pygtk/2.24/pygtk-2.24.0.tar.bz2'
  homepage 'http://www.pygtk.org'
  md5 'a1051d5794fd7696d3c1af6422d17a49'

  depends_on 'pygobject'
  depends_on 'py2cairo'

  def install
    system "./configure --prefix=#{prefix} --disable-dependency-tracking"
    system "make install" 
  end

end
