require "formula"

class OpenZwave < Formula
  homepage "http://www.openzwave.com"
  url "http://openzwave.com/downloads/openzwave-1.2.919.tar.gz"
  sha1 "514fa8a9e8468d264a6e4fffc377f2e18368ef41"

  def install
    ENV["BUILD"] = "release"
    ENV["PREFIX"] = prefix

    system "make", "install"
  end

  def caveats; <<-EOS.undent
    If using the Aeon Labs Z-Stick, you will need the driver available at
      http://aeotec.com/z-wave-usb-stick/1358-z-wave-drivers.html

    Once the driver is installed, the device will be available at
      /dev/cu.SLAB_USBtoUART
    EOS
  end
end
