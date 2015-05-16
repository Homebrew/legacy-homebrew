require "formula"

class Somagic < Formula
  homepage "https://code.google.com/p/easycap-somagic-linux/"
  url "https://easycap-somagic-linux.googlecode.com/files/somagic-easycap_1.1.tar.gz"
  sha1 "97cda956ea319fdd9aa9be9aff222a3e804deb91"

  depends_on "libusb"
  depends_on "libgcrypt"
  depends_on "somagic-tools"
  depends_on "mplayer" => :optional

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  def caveats; <<-EOS.undent
      Before running somagic-capture you must extract the official firmware from the CD.
      See https://code.google.com/p/easycap-somagic-linux/wiki/GettingStarted#Extracting_firmware for details.
    EOS
  end
end
