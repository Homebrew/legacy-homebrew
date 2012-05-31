require 'formula'

class Peg < Formula
  homepage 'http://piumarta.com/software/peg/'
  url 'http://piumarta.com/software/peg/peg-0.1.9.tar.gz'
  md5 '26888aff55d5578b8eb2b3f42c4ed587'

  def install
    system "make all"
    bin.install %w[peg leg]
    man1.install gzip("peg.1")
  end
end
