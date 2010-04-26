require 'formula'

class Libgphoto2 <Formula
  url 'http://downloads.sourceforge.net/project/gphoto/libgphoto/2.4.8/libgphoto2-2.4.8.tar.bz2'
  homepage 'http://gphoto.org/'
  md5 '7753f17dff15702466337aab05209a71'

  depends_on 'pkg-config'
  depends_on 'libusb-compat'
  depends_on 'libexif' => :optional

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
