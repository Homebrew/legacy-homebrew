require 'formula'

class Peg < Formula
  desc "Program to perform pattern matching on text"
  homepage 'http://piumarta.com/software/peg/'
  url 'http://piumarta.com/software/peg/peg-0.1.15.tar.gz'
  sha1 '85b8d85f3f6678372624d5013372ca7175604976'

  def install
    system "make all"
    bin.install %w[peg leg]
    man1.install gzip("src/peg.1")
  end
end
