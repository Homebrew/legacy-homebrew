require 'formula'

class Gmime < Formula
  homepage 'http://spruce.sourceforge.net/gmime/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/gmime/2.6/gmime-2.6.9.tar.xz'
  sha256 '5ebb60a35fa5c0789fe10f6e4af5040cb7bc4a707a8a962fbd57b4fc5595c0b9'

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'glib'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-largefile",
                          "--disable-mono",
                          "--disable-glibtest"
    system "make install"
  end
end
