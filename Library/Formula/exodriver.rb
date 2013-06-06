require 'formula'

class Exodriver < Formula
  homepage 'http://labjack.com/support/linux-and-mac-os-x-drivers'
  url 'https://github.com/labjack/exodriver/archive/v2.5.1.tar.gz'
  sha1 '7b8508670e3e46a0babdca1c0f38ab63fe1624ff'

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
