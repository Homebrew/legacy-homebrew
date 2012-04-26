require 'formula'

class Sec < Formula
  homepage 'http://simple-evcorr.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/simple-evcorr/sec/2.6.2/sec-2.6.2.tar.gz'
  md5 '18d3a0d5b80f7582945a82e2fad56831'

  def install
    bin.install 'sec'
    man1.install 'sec.man' => 'sec.1'
  end

  def test
    system "sec --version"
    system "man -w sec"
  end
end
