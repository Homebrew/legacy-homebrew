require 'formula'

class Bedtools < Formula
  url 'http://bedtools.googlecode.com/files/BEDTools.v2.14.3.tar.gz'
  homepage 'http://code.google.com/p/bedtools/'
  md5 '5b8638bf5fca93ee69347cbd241d1ca1'
  head 'https://github.com/arq5x/bedtools.git'

  def install
    system "make all"
    bin.install Dir['bin/*']
  end
end
