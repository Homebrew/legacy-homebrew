require 'formula'

class Gmime < Formula
  homepage 'http://spruce.sourceforge.net/gmime/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/gmime/2.6/gmime-2.6.19.tar.xz'
  sha256 'affb402b991519f83fb9c88464a9c07891860df18246c0743689c027d773a14a'

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
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
