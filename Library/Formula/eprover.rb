require 'formula'

class Eprover < Formula
  homepage 'http://www4.informatik.tu-muenchen.de/~schulz/E/E.html'
  url 'http://www4.in.tum.de/~schulz/WORK/E_DOWNLOAD/V_1.6/E.tgz'
  version '1.6'
  sha1 'd70add47b1a71ee2139d7e56a9118483dfc79ff5'

  def install
    system "./configure", "--bindir=#{bin}", "--man-prefix=#{man}"
    system "make install"
  end

  def test
    system "#{bin}/eproof"
  end
end
