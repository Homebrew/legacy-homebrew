require 'formula'

class Sfitsio < Formula
  url "http://www.ir.isas.jaxa.jp/~cyamauch/sli/sfitsio-1.4.2.tar.gz"
  homepage 'http://www.ir.isas.jaxa.jp/~cyamauch/sli/index.html#SFITSIO'
  sha1 '916db23bca3848118b268faa1ed756742aef4746'

  depends_on 'sllib'

  def install
    system  ("sh", "configure", "--prefix=#{prefix}")
    system "make"
    system "make install"
  end

  def test
    return true
  end
end
