require 'formula'

class Libgphoto2 < Formula
  url 'http://downloads.sourceforge.net/project/gphoto/libgphoto/2.4.11/libgphoto2-2.4.11.tar.bz2'
  md5 '16a22b9739e45a95980ed62705fe7333'
  homepage 'http://www.gphoto.org/proj/libgphoto2/'

  depends_on 'pkg-config' => :build
  depends_on 'libusb-compat'
  depends_on 'libexif' => :optional

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
