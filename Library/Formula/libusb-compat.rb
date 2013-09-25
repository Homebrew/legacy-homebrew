require 'formula'

class LibusbCompat < Formula
  homepage 'http://www.libusb.org/'
  url 'http://downloads.sourceforge.net/project/libusb/libusb-compat-0.1/libusb-compat-0.1.5/libusb-compat-0.1.5.tar.bz2'
  sha256 '404ef4b6b324be79ac1bfb3d839eac860fbc929e6acb1ef88793a6ea328bc55a'

  option :universal

  depends_on 'pkg-config' => :build
  depends_on 'libusb'

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
