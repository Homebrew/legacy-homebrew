require 'formula'

class Libnfc < Formula
  url 'http://libnfc.googlecode.com/files/libnfc-1.5.0.tar.gz'
  homepage 'http://www.libnfc.org/'
  md5 '569d85c36cd68f6e6560c9d78b46788f'

  depends_on 'libusb-compat'

  def options
    [
      ['--with-pn532_uart', 'Enable PN532 UART support'],
    ]
  end

  def install
    args = [
      "--prefix=#{prefix}",
      "--disable-debug",
      "--disable-dependency-tracking" ]

    if ARGV.include? '--with-pn532_uart'
      args << "--enable-serial-autoprobe"
      args << "--with-drivers=pn532_uart"
    end

    system "./configure", *args

    system "make install"
  end
end
