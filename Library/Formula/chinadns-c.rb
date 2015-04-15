class ChinadnsC < Formula
  homepage "https://github.com/clowwindy/ChinaDNS-C"
  url "https://github.com/clowwindy/ChinaDNS/releases/download/1.3.1/chinadns-1.3.1.tar.gz"
  sha1 "3bb6a7dd69c44e99e5794690cbc0efd4b73b7c4b"

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
