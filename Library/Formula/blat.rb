require 'formula'

class Blat < Formula
  homepage 'http://genome.ucsc.edu/FAQ/FAQblat.html'
  url 'http://users.soe.ucsc.edu/~kent/src/blatSrc35.zip'
  sha1 'b955529842ff2756c119f66f0ccb24135ffba5d6'

  def install
    bin.mkpath
    system "make", "MACHTYPE=darwin", "BINDIR=#{bin}"
  end

  def test
    system "#{bin}/blat |grep -q blat"
  end
end
