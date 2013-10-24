require 'formula'

class Dar < Formula
  homepage 'http://dar.linux.free.fr/doc/index.html'
  url 'http://downloads.sourceforge.net/project/dar/dar/2.4.10/dar-2.4.10.tar.gz'
  sha1 'bf02ba10bfcd2ad959017706f167fc390aafe932'

  depends_on 'gettext'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-build-html"
    system "make install"
  end
end
