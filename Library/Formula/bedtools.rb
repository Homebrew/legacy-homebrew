require 'formula'

class Bedtools < Formula
  url 'http://bedtools.googlecode.com/files/BEDTools.v2.12.0.tar.gz'
  homepage 'http://code.google.com/p/bedtools/'
  md5 'cc7839a96a7537a810bb645381a2ba8a'
  head 'git://github.com/arq5x/bedtools.git'

  def install
    system "make all"
    bin.install Dir['bin/*']
  end
end
