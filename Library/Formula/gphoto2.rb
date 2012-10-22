require 'formula'

class Gphoto2 < Formula
  homepage 'http://gphoto.org/'
  url 'http://downloads.sourceforge.net/project/gphoto/gphoto/2.5.0/gphoto2-2.5.0.tar.bz2'
  sha1 '4db56811b09e6496fb056f90effa4d7240b8e5dc'

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
