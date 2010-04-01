require 'formula'

class Pango <Formula
  url 'http://ftp.gnome.org/pub/gnome/sources/pango/1.26/pango-1.26.2.tar.bz2'
  homepage 'http://www.pango.org/'
  md5 'f30212b8833af3ce5c82121dc309e3d0'

  depends_on 'glib'
  depends_on 'pkg-config'

  def install
    system "./configure", "--prefix=#{prefix}", "--with-x"
    system "make install"
  end
end
