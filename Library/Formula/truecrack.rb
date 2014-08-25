require "formula"

class Truecrack < Formula
  homepage "https://code.google.com/p/truecrack/"
  url "https://truecrack.googlecode.com/files/truecrack_v35.tar.gz"
  sha1 "21b2a0f2f860ecf401cfc1ac8191638b7410fc64"
  version "3.5"

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
