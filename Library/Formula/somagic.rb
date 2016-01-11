class Somagic < Formula
  desc "Linux capture program for the Somagic variants of EasyCAP"
  homepage "https://code.google.com/p/easycap-somagic-linux/"
  url "https://easycap-somagic-linux.googlecode.com/files/somagic-easycap_1.1.tar.gz"
  sha256 "3a9dd78a47335a6d041cd5465d28124612dad97939c56d7c10e000484d78a320"

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
