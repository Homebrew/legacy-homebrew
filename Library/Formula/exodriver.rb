require 'formula'

class Exodriver < Formula
  homepage 'http://labjack.com/support/linux-and-mac-os-x-drivers'
  url 'https://github.com/labjack/exodriver/tarball/v2.5.1'
  sha1 '4c4ab59f84492fe65bc8e1785831a8a22b952690'

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
