require 'formula'

class Gmime <Formula
  url 'http://ftp.acc.umu.se/pub/GNOME/sources/gmime/2.4/gmime-2.4.14.tar.bz2'
  homepage 'http://spruce.sourceforge.net/gmime/'
  md5 '343d99e760f096bcea17059f01bad50c'

  depends_on 'glib'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-largefile",
                          "--disable-mono"
    system "make install"
  end
end
