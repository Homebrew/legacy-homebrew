class Dhcping < Formula
  homepage "http://www.mavetju.org/unix/general.php"
  url "http://www.mavetju.org/download/dhcping-1.2.tar.gz"
  sha256 "32ef86959b0bdce4b33d4b2b216eee7148f7de7037ced81b2116210bc7d3646a"

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end
end
