require 'formula'

class Gmime < Formula
  homepage 'http://spruce.sourceforge.net/gmime/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/gmime/2.6/gmime-2.6.17.tar.xz'
  sha256 '22d49e57c404a0a68d1ac3426c8f23a39185a4b2d569de03bece07db03d1202f'

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
