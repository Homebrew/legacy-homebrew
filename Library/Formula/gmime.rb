require 'formula'

class Gmime < Formula
  homepage 'http://spruce.sourceforge.net/gmime/'
  url 'ftp://ftp.gnome.org/pub/GNOME/sources/gmime/2.4/gmime-2.4.24.tar.bz2'
  sha256 'e1255dc565416b65e6f8e7b207074b86d955897169eb19a975e90b34ae660c14'

  depends_on 'glib'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-largefile",
                          "--disable-mono"
    system "make install"
  end
end
