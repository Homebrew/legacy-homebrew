require 'formula'

class Bedtools < Formula
  url 'http://bedtools.googlecode.com/files/BEDTools.v2.13.3.tar.gz'
  homepage 'http://code.google.com/p/bedtools/'
  md5 '4119b0e84d49b0a7425070c82b4d1920'
  head 'https://github.com/arq5x/bedtools.git'

  def install
    system "make all"
    bin.install Dir['bin/*']
  end
end
