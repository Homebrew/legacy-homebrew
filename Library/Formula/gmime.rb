require 'formula'

class Gmime <Formula
  url 'http://ftp.acc.umu.se/pub/GNOME/sources/gmime/2.4/gmime-2.4.20.tar.bz2'
  homepage 'http://spruce.sourceforge.net/gmime/'
  sha256 'e13ea84678d92fd08a44b06b589a25e07af093634d490caad123b2eead14b990'

  depends_on 'glib'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-largefile",
                          "--disable-mono"
    system "make install"
  end
end
