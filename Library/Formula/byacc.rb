require "formula"

class Byacc < Formula
  homepage "http://invisible-island.net/byacc/byacc.html"
  url "ftp://invisible-island.net/byacc/byacc-20140422.tgz"
  sha1 "aa30cac1e7b3cf9d6d19d6b9653575d56564b213"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--program-prefix=b",
                          "--prefix=#{prefix}",
                          "--man=#{man}"
    system "make install"
  end
end
