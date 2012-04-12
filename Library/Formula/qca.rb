require 'formula'

class Qca < Formula
  url 'http://delta.affinix.com/download/qca/2.0/qca-2.0.2.tar.bz2'
  homepage 'http://delta.affinix.com/qca/'
  md5 '27ebdfbd9869d90dae078a6decd029f4'

  depends_on 'qt'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
