class ChinadnsC < Formula
  homepage "https://github.com/clowwindy/ChinaDNS-C"
  url "https://github.com/clowwindy/ChinaDNS/releases/download/1.3.0/chinadns-1.3.0.tar.gz"
  sha1 "0877eed8bb385ca72cede3b3fca35f5d5e40e999"

  bottle do
    cellar :any
    sha1 "68b1bee30ce1870bce29680ef25d3a180674ecd3" => :yosemite
    sha1 "53c4a55f0bf19f11d06a4d80200fd9e4fc5040ef" => :mavericks
    sha1 "1ce8fcc9e873ca5aa24133fb0b0c0bd98fde27d3" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "chinadns", "-h"
  end
end
