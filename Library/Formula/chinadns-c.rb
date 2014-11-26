require "formula"

class ChinadnsC < Formula
  homepage "https://github.com/clowwindy/ChinaDNS-C"
  url "https://github.com/clowwindy/ChinaDNS-C/releases/download/1.1.8/chinadns-c-1.1.8.tar.gz"
  sha1 "e712aab436e555a242f6c3c8acd7474b0b445bf1"

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
