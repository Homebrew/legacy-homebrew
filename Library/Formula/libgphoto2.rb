require 'formula'

class Libgphoto2 <Formula
  url 'http://downloads.sourceforge.net/project/gphoto/libgphoto/2.4.9.1/libgphoto2-2.4.9.1.tar.bz2'
  md5 '7ad1c1bf906abed4d2799a6f6a3e4f75'

  depends_on 'pkg-config'
  depends_on 'libusb-compat'
  depends_on 'libexif' => :optional

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
