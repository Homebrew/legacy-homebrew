class Testdisk < Formula
  desc "TestDisk is a powerful free data recovery utility"
  homepage "http://www.cgsecurity.org/wiki/TestDisk"
  url "http://www.cgsecurity.org/testdisk-7.0.tar.bz2"
  sha256 "00bb3b6b22e6aba88580eeb887037aef026968c21a87b5f906c6652cbee3442d"

  bottle do
    cellar :any_skip_relocation
    sha256 "244b1c7a5e6beec940bb5ee4a27f54be138a1df732d9eb276d5798e7f947799c" => :el_capitan
    sha256 "0ca542c57ca8ed24c3ecb5d5b449dc18fda306744309fb59598e2a7e9c55c08b" => :yosemite
    sha256 "e537da6b508c8aac5842c3d2094b5b914effea9ea04484cf09ac9bb80d46e3f0" => :mavericks
    sha256 "afbf7d1f54c14b40d86baadc34efeaed0399257598d60755d910aec978aee7ef" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = "test.dmg"
    system "hdiutil", "create", "-megabytes", "10", path
    system "#{bin}/testdisk", "/list", path
  end
end
