require 'formula'

class Gmime < Formula
  homepage 'http://spruce.sourceforge.net/gmime/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/gmime/2.6/gmime-2.6.15.tar.xz'
  sha256 'b4c2a0b99b82063387cd750a38421ebaa0636f339e67984a84371bcb697dc99a'

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
