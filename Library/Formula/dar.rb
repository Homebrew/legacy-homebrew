require 'formula'

class Dar <Formula
  url 'http://downloads.sourceforge.net/project/dar/dar/2.3.10/dar-2.3.10.tar.gz'
  homepage 'http://dar.linux.free.fr/doc/index.html'
  md5 'f134276bb9dc761dbb318c5511e65833'

  depends_on 'gettext'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}",
                          "--disable-build-html"
    system "make install"
  end
end
