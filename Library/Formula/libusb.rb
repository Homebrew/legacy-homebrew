require 'formula'

class Libusb < Formula
  homepage 'http://www.libusb.org/'
  url 'http://downloads.sourceforge.net/project/libusb/libusb-1.0/libusb-1.0.9/libusb-1.0.9.tar.bz2'
  sha256 'e920eedc2d06b09606611c99ec7304413c6784cba6e33928e78243d323195f9b'

  head 'git://git.libusb.org/libusb.git'

  def options
    [["--universal", "Build a universal binary."]]
  end

  if ARGV.build_head? and MacOS.xcode_version >= "4.3"
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    ENV.universal_binary if ARGV.build_universal?
    system "./autogen.sh" if ARGV.build_head?
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
