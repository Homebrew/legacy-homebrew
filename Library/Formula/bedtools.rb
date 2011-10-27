require 'formula'

class Bedtools < Formula
  url 'http://bedtools.googlecode.com/files/BEDTools.v2.13.4.tar.gz'
  homepage 'http://code.google.com/p/bedtools/'
  md5 '47383058bd48fb64da878e85c5eb1a4a'
  head 'https://github.com/arq5x/bedtools.git'

  def install
    system "make all"
    bin.install Dir['bin/*']
  end
end
