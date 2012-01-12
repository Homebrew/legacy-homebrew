require 'formula'

class Bedtools < Formula
  url 'http://bedtools.googlecode.com/files/BEDTools.v2.15.0.tar.gz'
  homepage 'http://code.google.com/p/bedtools/'
  md5 'c0cbcb748f54ed99fce47c687bd0f260'
  head 'https://github.com/arq5x/bedtools.git'

  def install
    system "make all"
    bin.install Dir['bin/*']
  end
end
