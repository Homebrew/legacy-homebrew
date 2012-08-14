require 'formula'

class Gphoto2 < Formula
  homepage 'http://gphoto.org/'
  url 'http://downloads.sourceforge.net/project/gphoto/gphoto/2.4.14/gphoto2-2.4.14.tar.bz2'
  sha1 'e15d9795f10a18c1e8e2ddbd3a99d982b141a625'

  depends_on 'pkg-config' => :build
  depends_on 'jpeg'
  depends_on 'libgphoto2'
  depends_on 'popt'
  depends_on 'readline'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
