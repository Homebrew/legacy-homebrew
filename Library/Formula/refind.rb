class Refind < Formula
  homepage "http://www.rodsbooks.com/refind/"
  url "https://downloads.sourceforge.net/project/refind/0.8.4/refind-bin-0.8.4.zip"
  sha1 "f219383924ef60cb6d147267f9ee44810c1f473f"

  def install
    system "sudo", "bash", "install.sh"
  end
end
