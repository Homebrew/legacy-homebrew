require 'formula'

class Bedtools < Formula
  url 'http://bedtools.googlecode.com/files/BEDTools.v2.16.1.tar.gz'
  homepage 'http://code.google.com/p/bedtools/'
  md5 'f9356528d6c70b2f25a91f0464a539f9'
  head 'https://github.com/arq5x/bedtools.git'

  def install
    system "make all"
    bin.install Dir['bin/*']
  end
end
