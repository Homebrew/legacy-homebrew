require 'formula'

class Libgphoto2 < Formula
  homepage 'http://www.gphoto.org/proj/libgphoto2/'
  url 'http://downloads.sourceforge.net/project/gphoto/libgphoto/2.4.13/libgphoto2-2.4.13.tar.bz2'
  md5 'd20a32fe2bb7d802a6a8c3b6f7f97c5e'

  depends_on 'pkg-config' => :build
  depends_on 'libusb-compat'
  depends_on 'libexif' => :optional

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
