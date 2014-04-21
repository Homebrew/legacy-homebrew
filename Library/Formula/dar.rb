require 'formula'

class Dar < Formula
  homepage 'http://dar.linux.free.fr/doc/index.html'
  url 'https://downloads.sourceforge.net/project/dar/dar/2.4.13/dar-2.4.13.tar.gz'
  sha1 'b20471ada21cd0cbe4687e7bdd3c2e6f70f5c0d1'

  depends_on 'gettext'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-build-html"
    system "make install"
  end
end
