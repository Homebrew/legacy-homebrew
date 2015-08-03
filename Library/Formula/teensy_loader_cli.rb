class TeensyLoaderCli < Formula
  desc "Command-line integration for Teensy USB development boards"
  homepage "https://www.pjrc.com/teensy/loader_cli.html"
  url "https://www.pjrc.com/teensy/teensy_loader_cli.2.1.zip"
  sha256 "dafd040d6748b52e0d4a01846d4136f3354ca27ddc36a55ed00d0a0af0902d46"

  def install
    ENV["OS"] = "MACOSX"
    ENV["SDK"] = MacOS.sdk_path || "/"
    system "make"
    bin.install "teensy_loader_cli"
  end

  test do
    assert `#{bin}/teensy_loader_cli 2>&1`.include?("<MCU> = atmega32u4 | at90usb162 | at90usb646 | at90usb1286")
  end
end
