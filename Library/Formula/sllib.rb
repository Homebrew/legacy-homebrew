require 'formula'

class Sllib < Formula
  url "http://www.ir.isas.jaxa.jp/~cyamauch/sli/sllib-1.4.2.tar.gz"
  homepage 'http://www.ir.isas.jaxa.jp/~cyamauch/sli/index.html'
  sha1 'b55522796ac43fa6f9c8341fc54367f1cf334a28'

  def install
    system  ("sh", "configure", "--prefix=#{prefix}")
    system "make"
    system "make install"
  end

  def test
    return true
  end
end
