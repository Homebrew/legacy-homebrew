require 'formula'

class Gmime < Formula
  homepage 'http://spruce.sourceforge.net/gmime/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/gmime/2.6/gmime-2.6.20.tar.xz'
  sha256 'e0a170fb264c2ae4cecd852f4e7aaddb8d58e8f3f0b569ce2d2a4704f55bdf65'

  depends_on 'pkg-config' => :build
  depends_on 'libgpg-error' => :build
  depends_on 'glib'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-largefile",
                          "--disable-introspection",
                          "--disable-vala",
                          "--disable-mono",
                          "--disable-glibtest"
    system "make install"
  end
end
