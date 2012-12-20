require 'formula'

class Libgphoto2 < Formula
  homepage 'http://www.gphoto.org/proj/libgphoto2/'
  url 'http://downloads.sourceforge.net/project/gphoto/libgphoto/2.5.0/libgphoto2-2.5.0.tar.bz2'
  sha1 'b8383933525b71308b3b24ba43c88a4c5d999cf8'

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
