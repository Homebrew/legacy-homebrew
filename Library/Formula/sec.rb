require 'formula'

class Sec < Formula
  homepage 'http://simple-evcorr.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/simple-evcorr/sec/2.6.2/sec-2.6.2.tar.gz'
  sha1 'bce0717c59ef1310fcad14ee1f90f4c05f89c4c0'

  def install
    bin.install 'sec'
    man1.install 'sec.man' => 'sec.1'
  end

  def test
    system "#{bin}/sec --version"
  end
end
