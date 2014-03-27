require 'formula'

class Libgphoto2 < Formula
  homepage 'http://www.gphoto.org/proj/libgphoto2/'
  url 'https://downloads.sourceforge.net/project/gphoto/libgphoto/2.5.3.1/libgphoto2-2.5.3.1.tar.bz2'
  sha1 '6e5c9254c65d4768ac4e4c1a423147542005987f'

  option :universal

  depends_on 'pkg-config' => :build
  depends_on :libtool => :run
  depends_on 'libusb-compat'
  depends_on 'gd'
  depends_on 'libexif' => :optional

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "CFLAGS=-D_DARWIN_C_SOURCE"
    system "make install"
  end
end
