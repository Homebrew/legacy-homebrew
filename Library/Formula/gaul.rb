class Gaul < Formula
  desc "Genetic Algorithm Utility Library"
  homepage "http://gaul.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/gaul/gaul-devel/0.1850-0/gaul-devel-0.1850-0.tar.gz"
  sha256 "7aabb5c1c218911054164c3fca4f5c5f0b9c8d9bab8b2273f48a3ff573da6570"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug",
                          "--disable-g",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
