require "formula"

class Truecrack < Formula
  homepage "https://code.google.com/p/truecrack/"
  url "https://truecrack.googlecode.com/files/truecrack_v35.tar.gz"
  sha1 "21b2a0f2f860ecf401cfc1ac8191638b7410fc64"
  version "3.5"

  bottle do
    cellar :any
    sha1 "605d9c2eda636f918413f4ae3d9146bfa5168516" => :mavericks
    sha1 "a320ed86f967c5b0e430c6506804f5a1574d3143" => :mountain_lion
    sha1 "67c8b6637db713e7582f6db320fdc1926e7f531b" => :lion
  end

  # Fix missing return value compilation issue
  # https://code.google.com/p/truecrack/issues/detail?id=41
  patch do
    url "https://gist.githubusercontent.com/anonymous/b912a1ede06eb1e8eb38/raw/1394a8a6bedb7caae8ee034f512f76a99fe55976/truecrack-return-value-fix.patch"
    sha1 "6a0fa8a58284dec2352e7c090f68bb03d4dc75ab"
  end

  def install
    system "./configure", "--enable-cpu",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/truecrack"
  end
end
