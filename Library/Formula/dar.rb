require 'formula'

class Dar < Formula
  homepage 'http://dar.linux.free.fr/doc/index.html'
  url 'http://sourceforge.net/projects/dar/files/dar/2.4.7/dar-2.4.7.tar.gz'
  sha1 '5145213429cfba12f92618c43e9a7733a85c26d3'

  depends_on 'gettext'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-build-html"
    system "make install"
  end
end
