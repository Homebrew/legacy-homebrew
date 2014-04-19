require 'formula'

class Exodriver < Formula
  homepage 'http://labjack.com/support/linux-and-mac-os-x-drivers'
  url 'https://github.com/labjack/exodriver/archive/v2.5.3.tar.gz'
  sha1 'd21529987962b1e7178ec7331fc14700caed0692'

  head 'https://github.com/labjack/exodriver.git'

  depends_on 'libusb'

  option :universal

  def install
    ENV.universal_binary if build.universal?

    cd 'liblabjackusb'
    system "make", "-f", "Makefile",
                   "DESTINATION=#{lib}",
                   "HEADER_DESTINATION=#{include}",
                   "install"
  end
end
