require "formula"

class SomagicTools < Formula
  homepage "https://code.google.com/p/easycap-somagic-linux/"
  url "https://easycap-somagic-linux.googlecode.com/files/somagic-easycap-tools_1.1.tar.gz"
  sha1 "e6bce8395a5c2c70c0c5809251b240a2cf618093"

  depends_on "libusb"
  depends_on "libgcrypt"

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end
end
