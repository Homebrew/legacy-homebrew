require 'formula'

class Bedtools < Formula
  url 'http://bedtools.googlecode.com/files/BEDTools.v2.16.2.tar.gz'
  homepage 'http://code.google.com/p/bedtools/'
  md5 'a627ec8da816f62b14d5be74083c0206'
  head 'https://github.com/arq5x/bedtools.git'

  def install
    system "make all"
    bin.install Dir['bin/*']
  end
end
