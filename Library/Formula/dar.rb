require 'formula'

class Dar < Formula
  url 'http://downloads.sourceforge.net/project/dar/dar/2.4.2/dar-2.4.2.tar.gz'
  homepage 'http://dar.linux.free.fr/doc/index.html'
  md5 'b23c0509513b895f4ab9ce9191b2f65b'

  depends_on 'gettext'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}",
                          "--disable-build-html"
    system "make install"
  end
end
