require "formula"

class TeensyLoaderCli < Formula
  homepage "https://www.pjrc.com/teensy/loader_cli.html"
  url "https://www.pjrc.com/teensy/teensy_loader_cli.2.1.zip"
  sha1 "041459720e733f78ba4e6a14abdbaa8bf04eb007"

  def install
    ENV['OS'] = 'MACOSX'
    ENV['SDK'] = MacOS.sdk_path || "/"
    system "make"
    bin.install "teensy_loader_cli"
  end

  test do
    assert `#{bin}/teensy_loader_cli 2>&1`.include?('<MCU> = atmega32u4 | at90usb162 | at90usb646 | at90usb1286')
  end
end
