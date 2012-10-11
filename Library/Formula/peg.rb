require 'formula'

class Peg < Formula
  homepage 'http://piumarta.com/software/peg/'
  url 'http://piumarta.com/software/peg/peg-0.1.9.tar.gz'
  sha1 '40a3dd06264fef8aaaedcc88f198c0641bf4190d'

  def install
    system "make all"
    bin.install %w[peg leg]
    man1.install gzip("peg.1")
  end
end
