class TeensyLoaderCli < Formula
  desc "Command-line integration for Teensy USB development boards"
  homepage "https://www.pjrc.com/teensy/loader_cli.html"
  depends_on "libusb-compat"

  url "https://www.pjrc.com/teensy/teensy_loader_cli.2.1.zip"
  sha256 "dafd040d6748b52e0d4a01846d4136f3354ca27ddc36a55ed00d0a0af0902d46"

  head do
    url "https://github.com/PaulStoffregen/teensy_loader_cli.git"
    patch do
      url "https://github.com/rixtox/teensy_loader_cli/commit/747f3a249722eb07b494b2db8c7f872e603448f3.diff"
      sha256 "be47f352d6f54a88db0bc8a88062f9ec470cab2c675655cfec14a9c238492677"
    end
  end

  def install
    ENV["OS"] = "LINUX"
    system "make"
    bin.install "teensy_loader_cli"
  end

  test do
    assert `#{bin}/teensy_loader_cli 2>&1`.include?("<MCU> = atmega32u4 | at90usb162 | at90usb646 | at90usb1286")
  end
end
