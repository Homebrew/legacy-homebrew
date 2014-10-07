require "formula"

class Ocrad < Formula
  homepage "https://www.gnu.org/software/ocrad/"
  url "http://ftpmirror.gnu.org/ocrad/ocrad-0.24.tar.lz"
  mirror "https://ftp.gnu.org/gnu/ocrad/ocrad-0.24.tar.lz"
  sha1 "b46bbb4b57a3bf2d544cedca47b40f24d8aa811a"

  bottle do
    cellar :any
    sha1 "a3714c9fe1685bf247ba7ff127a098eb1ac0b9d9" => :mavericks
    sha1 "fbc42888aa3700c6420eedb6aa3c7aea27d2e80d" => :mountain_lion
    sha1 "3bc70ab2c0df8e0368990d146c03c34ed29d1e9a" => :lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install", "CXXFLAGS=#{ENV.cxxflags}"
  end

  test do
    system "#{bin}/ocrad", "-h"
  end
end
