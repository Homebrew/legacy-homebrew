require 'formula'

class Qca < Formula
  url 'http://delta.affinix.com/download/qca/2.0/qca-2.0.3.tar.bz2'
  homepage 'http://delta.affinix.com/qca/'
  md5 'fc15bd4da22b8096c51fcfe52d2fa309'

  depends_on 'qt'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
