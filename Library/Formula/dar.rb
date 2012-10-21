require 'formula'

class Dar < Formula
  homepage 'http://dar.linux.free.fr/doc/index.html'
  url 'http://sourceforge.net/projects/dar/files/dar/2.4.8/dar-2.4.8.tar.gz'
  sha1 '13f9a806da44542446e986169a3390c577c479d9'

  depends_on 'gettext'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-build-html"
    system "make install"
  end
end
