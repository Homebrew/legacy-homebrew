require 'formula'

class Bedtools < Formula
  url 'http://bedtools.googlecode.com/files/BEDTools.v2.16.2.tar.gz'
  homepage 'http://code.google.com/p/bedtools/'
  sha1 'f9580cc9394713e0575fd73492ed6bf64a2256c6'
  head 'https://github.com/arq5x/bedtools.git'

  def install
    system "make all"
    bin.install Dir['bin/*']
  end
end
