require 'formula'

class Atk <Formula
  url 'ftp://ftp.gnome.org/pub/gnome/sources/atk/1.28/atk-1.28.0.tar.bz2'
  homepage 'http://library.gnome.org/devel/atk/'
  md5 '010a85478adc053c016a0a5c9bb52004'

  depends_on 'pkg-config'
  depends_on 'glib'
  
  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
