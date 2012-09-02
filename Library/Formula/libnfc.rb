require 'formula'

class Libnfc < Formula
  homepage 'http://www.libnfc.org/'
  url 'http://libnfc.googlecode.com/files/libnfc-1.5.1.tar.gz'
  sha1 'aebd4a126f2268d06ade445cd6cf2b3c59256f51'

  depends_on 'libusb-compat'

  option 'with-pn532_uart', 'Enable PN532 UART support'

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    if build.include? 'with-pn532_uart'
      args << "--enable-serial-autoprobe"
      args << "--with-drivers=pn532_uart"
    end

    system "./configure", *args
    system "make install"
  end
end
