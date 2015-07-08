class Prips < Formula
  desc "Print the IP addresses in a given range"
  homepage "http://devel.ringlet.net/sysutils/prips/"
  url "http://devel.ringlet.net/sysutils/prips/prips-0.9.9.tar.gz"
  sha256 "ad9d8e63cd69ed682ea87c154a19e5c58a3eb4bb3a118d5f458fd86eadb3bef8"

  def install
    system "make"
    bin.install "prips"
    man1.install "prips.1"
  end

  test do
    assert_equal "127.0.0.0\n127.0.0.1",
      shell_output("#{bin}/prips 127.0.0.0/31").strip
  end
end
