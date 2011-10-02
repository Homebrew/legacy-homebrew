require 'formula'

class Bedtools < Formula
  url 'http://bedtools.googlecode.com/files/BEDTools.v2.13.2.tar.gz'
  homepage 'http://code.google.com/p/bedtools/'
  md5 'cd3671eda69da312237523beadefbd52'
  head 'https://github.com/arq5x/bedtools.git'

  def install
    system "make all"
    bin.install Dir['bin/*']
  end
end
