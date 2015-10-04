class SomagicTools < Formula
  desc "Tools to extract firmware from EasyCAP"
  homepage "https://code.google.com/p/easycap-somagic-linux/"
  url "https://easycap-somagic-linux.googlecode.com/files/somagic-easycap-tools_1.1.tar.gz"
  sha256 "b091723c55e6910cbf36c88f8d37a8d69856868691899683ec70c83b122a0715"

  depends_on "libusb"
  depends_on "libgcrypt"

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end
end
