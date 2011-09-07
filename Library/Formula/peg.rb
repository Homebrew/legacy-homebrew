require 'formula'

class Peg < Formula
  url 'http://piumarta.com/software/peg/peg-0.1.4.tar.gz'
  homepage 'http://piumarta.com/software/peg/'
  md5 'feb52a19a749f08fa8602387f1acbd93'

  def install
    system "make all"
    bin.install %w[peg leg]
    man1.install gzip("peg.1")
  end
end
