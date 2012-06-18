require 'formula'

class Dar < Formula
  homepage 'http://dar.linux.free.fr/doc/index.html'
  url 'http://downloads.sourceforge.net/project/dar/dar/2.4.5/dar-2.4.5.tar.gz'
  sha1 '4c1f6982227aa8143bf969fc1b96432830aa33f9'

  depends_on 'gettext'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-build-html"
    system "make install"
  end
end
