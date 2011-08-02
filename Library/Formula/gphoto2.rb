require 'formula'

class Gphoto2 < Formula
  url 'http://downloads.sourceforge.net/project/gphoto/gphoto/2.4.10/gphoto2-2.4.10.tar.bz2'
  homepage 'http://gphoto.org/'
  md5 '3c86c9824b9bfc57a52be5f84ad205f7'

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
