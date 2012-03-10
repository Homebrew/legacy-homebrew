require 'formula'

class Eprover < Formula
  url 'http://www4.in.tum.de/~schulz/WORK/E_DOWNLOAD/V_1.4/E.tgz'
  homepage 'http://www4.informatik.tu-muenchen.de/~schulz/E/E.html'
  md5 '4da7b0c06dddd96ce8ffeb77462d7f77'
  version '1.4'

  def install
    system "./configure", "--bindir=#{bin}", "--man-prefix=#{man}"
    system "make install"
  end

  def test
    system "eproof"
  end
end
