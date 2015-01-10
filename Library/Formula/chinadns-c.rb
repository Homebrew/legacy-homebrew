class ChinadnsC < Formula
  homepage "https://github.com/clowwindy/ChinaDNS-C"
  url "https://github.com/clowwindy/ChinaDNS/releases/download/1.2.2/chinadns-1.2.2.tar.gz"
  sha1 "6498dacfce023d56699f80bcf1fed9fd9eda99d9"

  bottle do
    cellar :any
    sha1 "1534c5254c1c2d62585f9c47cd931ce973d4ab0e" => :yosemite
    sha1 "0e3acccedeacedf20602574c9364a86a62e67195" => :mavericks
    sha1 "1287a11becbb9dffe25cba272b77a3c2eb3b4d75" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "chinadns", "-h"
  end
end
