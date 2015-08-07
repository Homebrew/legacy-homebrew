class Exodriver < Formula
  desc "Thin interface to LabJack devices"
  homepage "http://labjack.com/support/linux-and-mac-os-x-drivers"
  url "https://github.com/labjack/exodriver/archive/v2.5.3.tar.gz"
  sha256 "24cae64bbbb29dc0ef13f482f065a14d075d2e975b7765abed91f1f8504ac2a5"

  head "https://github.com/labjack/exodriver.git"

  depends_on "libusb"

  option :universal

  def install
    ENV.universal_binary if build.universal?

    cd "liblabjackusb"
    system "make", "-f", "Makefile",
                   "DESTINATION=#{lib}",
                   "HEADER_DESTINATION=#{include}",
                   "install"
  end
end
