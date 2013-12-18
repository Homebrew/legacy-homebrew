require 'formula'

class Peg < Formula
  homepage 'http://piumarta.com/software/peg/'
  url 'http://piumarta.com/software/peg/peg-0.1.13.tar.gz'
  sha1 'ecf33104907ed18339395874245a6a0bd2b4f515'

  def install
    system "make all"
    bin.install %w[peg leg]
    man1.install gzip("src/peg.1")
  end
end
