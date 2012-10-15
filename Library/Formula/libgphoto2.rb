require 'formula'

class Libgphoto2 < Formula
  homepage 'http://www.gphoto.org/proj/libgphoto2/'
  url 'http://downloads.sourceforge.net/project/gphoto/libgphoto/2.4.14/libgphoto2-2.4.14.tar.bz2'
  sha1 'c932f44d51e820245ff3394ee01a5e9df429dfef'

  depends_on 'pkg-config' => :build
  depends_on :libtool # Configure script uses this
  depends_on 'libusb-compat'
  depends_on 'libexif' => :optional

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
