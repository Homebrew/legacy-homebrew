class Testdisk < Formula
  homepage "http://www.cgsecurity.org/wiki/TestDisk"
  url "http://www.cgsecurity.org/testdisk-7.0.tar.bz2"
  sha256 "00bb3b6b22e6aba88580eeb887037aef026968c21a87b5f906c6652cbee3442d"

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
