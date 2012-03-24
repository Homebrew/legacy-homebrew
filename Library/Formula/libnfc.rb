require 'formula'

class Libnfc < Formula
  url 'http://libnfc.googlecode.com/files/libnfc-1.5.1.tar.gz'
  homepage 'http://www.libnfc.org/'
  md5 '81e3e59496060dc495c95844654a8038'

  depends_on 'libusb-compat'

  def options
    [['--with-pn532_uart', 'Enable PN532 UART support']]
  end

  def install
    args = ["--disable-debug", "--disable-dependency-tracking",
            "--prefix=#{prefix}"]

    if ARGV.include? '--with-pn532_uart'
      args << "--enable-serial-autoprobe"
      args << "--with-drivers=pn532_uart"
    end

    system "./configure", *args
    system "make install"
  end
end
