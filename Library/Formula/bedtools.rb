require 'formula'

class Bedtools < Formula
  homepage 'http://code.google.com/p/bedtools/'
  url 'http://bedtools.googlecode.com/files/BEDTools.v2.17.0.tar.gz'
  sha1 '1b1de3c35394a423f9ad98a9957a8853b426a578'

  head 'https://github.com/arq5x/bedtools.git'

  def install
    system "make all"
    prefix.install 'bin'
  end
end
