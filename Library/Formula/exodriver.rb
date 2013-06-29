require 'formula'

class Exodriver < Formula
  homepage 'http://labjack.com/support/linux-and-mac-os-x-drivers'
  url 'https://github.com/labjack/exodriver/archive/v2.5.2.tar.gz'
  sha1 '8d53bb3eda8a62c0399e3ea6657fe2b22eeffaac'

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
