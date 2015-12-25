class Testdisk < Formula
  desc "TestDisk is a powerful free data recovery utility"
  homepage "https://www.cgsecurity.org/wiki/TestDisk"
  url "https://www.cgsecurity.org/testdisk-7.0.tar.bz2"
  sha256 "00bb3b6b22e6aba88580eeb887037aef026968c21a87b5f906c6652cbee3442d"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "979d1f6ba12aeee68300a657a78a234874707068232934d7f91597621a60253e" => :el_capitan
    sha256 "13f6481decb5ad3f40f0617351dd9c78a02c3c0694a82cb048adde6ba897703f" => :yosemite
    sha256 "d3e8a600a135807b630a4d649c052dc6065270910bd96f6b1f27265251787331" => :mavericks
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
