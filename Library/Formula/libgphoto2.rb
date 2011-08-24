require 'formula'

class Libgphoto2 < Formula
  url 'http://downloads.sourceforge.net/project/gphoto/libgphoto/2.4.10.1/libgphoto2-2.4.10.1.tar.bz2'
  md5 '362cd914c64b2363f4d0bd5ad07c7209'
  homepage 'http://www.gphoto.org/proj/libgphoto2/'

  depends_on 'pkg-config' => :build
  depends_on 'libusb-compat'
  depends_on 'libexif' => :optional

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
