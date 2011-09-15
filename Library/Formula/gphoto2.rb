require 'formula'

class Gphoto2 < Formula
  url 'http://downloads.sourceforge.net/project/gphoto/gphoto/2.4.11/gphoto2-2.4.11.tar.bz2'
  homepage 'http://gphoto.org/'
  md5 '2635075f702b40eb2e95a80658bd4773'

  depends_on 'pkg-config' => :build
  depends_on 'jpeg'
  depends_on 'libgphoto2'
  depends_on 'popt'
  depends_on 'readline'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-aalib"
    system "make install"
  end
end
