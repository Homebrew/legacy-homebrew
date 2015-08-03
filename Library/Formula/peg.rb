class Peg < Formula
  desc "Program to perform pattern matching on text"
  homepage "http://piumarta.com/software/peg/"
  url "http://piumarta.com/software/peg/peg-0.1.15.tar.gz"
  sha256 "b6736ca15e5eb9154596e620ebad94a4705c7e597fc97b11219a90fc171faef2"

  def install
    system "make", "all"
    bin.install %w[peg leg]
    man1.install gzip("src/peg.1")
  end
end
