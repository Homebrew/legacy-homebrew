require 'formula'

class Libusb < Formula
  homepage 'http://www.libusb.org/'
  url 'http://downloads.sourceforge.net/project/libusb/libusb-1.0/libusb-1.0.9/libusb-1.0.9.tar.bz2'
  sha256 'e920eedc2d06b09606611c99ec7304413c6784cba6e33928e78243d323195f9b'

  head do
    url 'git://git.libusb.org/libusb.git'

    depends_on :automake
    depends_on :libtool
  end

  option :universal

  conflicts_with 'libusbx',
    :because => 'both provide libusb compatible libraries'

  def install
    ENV.universal_binary if build.universal?

    if build.head?
      inreplace "configure.ac", "AM_CONFIG_HEADER", "AC_CONFIG_HEADERS"
      system "./autogen.sh"
    end

    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
