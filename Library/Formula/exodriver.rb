require 'formula'

class Exodriver < Formula
  homepage 'http://labjack.com/support/linux-and-mac-os-x-drivers'
  url 'https://github.com/labjack/exodriver/tarball/v2.0.4'
  md5 '9208085ee8a9166898dc812b9d7e1905'

  head 'https://github.com/labjack/exodriver.git'

  depends_on 'libusb'

  def options
    [["--universal", "Build a universal binary."]]
  end

  def install
    ENV.universal_binary if ARGV.build_universal?

    cd 'liblabjackusb'
    system "make", "-f", "Makefile.MacOSX",
                   "DESTINATION=#{lib}",
                   "HEADER_DESTINATION=#{include}",
                   "install"
  end
end
