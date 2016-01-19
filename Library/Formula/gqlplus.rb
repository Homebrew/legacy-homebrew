class Gqlplus < Formula
  desc "Drop-in replacement for sqlplus, an Oracle SQL client"
  homepage "http://gqlplus.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/gqlplus/gqlplus/1.15/gqlplus-1.15.tar.gz"
  sha256 "9a539cdcf952b4acd2ae2d940772366bf6c9ee0fb51846c02d3c7dc1df3056d5"

  depends_on "readline"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    bin.install "gqlplus"
  end
end
