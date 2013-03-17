require 'formula'

class Libgphoto2 < Formula
  homepage 'http://www.gphoto.org/proj/libgphoto2/'
  url 'http://downloads.sourceforge.net/project/gphoto/libgphoto/2.5.1/libgphoto2-2.5.1.tar.bz2'
  sha1 '22ea99af344ca712db4d87a506ca2fc34c70e61a'

  depends_on 'pkg-config' => :build
  depends_on :libtool # Configure script uses this
  depends_on 'libusb-compat'
  depends_on 'libexif' => :optional

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "CFLAGS=-D_DARWIN_C_SOURCE"
    system "make install"
  end
end
