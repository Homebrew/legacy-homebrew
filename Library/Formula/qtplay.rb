class Qtplay < Formula
  desc "Play audio CDs, MP3s, and other music files"
  homepage "https://sites.google.com/site/rainbowflight2/"
  url "https://sites.google.com/site/rainbowflight2/qtplay1.3.1.tar.gz"
  sha256 "5d0d5bda455d77057a2372925a2c1da09ef82b5969ef0342e61d8b63876ed840"

  def install
    # Only a 32-bit binary is supported
    system ENV.cc, "qtplay.c", "-arch", "i386", "-framework", "QuickTime", "-framework", "Carbon", "-o", "qtplay"
    bin.install "qtplay"
    man1.install "qtplay.1"
  end

  test do
    system "#{bin}/qtplay", "--help"
  end
end
