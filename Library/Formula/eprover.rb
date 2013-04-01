require 'formula'

class Eprover < Formula
  homepage 'http://www4.informatik.tu-muenchen.de/~schulz/E/E.html'
  url 'http://www4.in.tum.de/~schulz/WORK/E_DOWNLOAD/V_1.7/E.tgz'
  version '1.7'
  sha1 '66b0160a80d41cae2a8838ccc3af0510eda8d0e4'

  def install
    system "./configure", "--bindir=#{bin}", "--man-prefix=#{man}"
    system "make install"
  end

  def test
    system "#{bin}/eproof"
  end
end
