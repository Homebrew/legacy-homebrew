require 'formula'

class Pari < Formula
  url 'http://pari.math.u-bordeaux.fr/pub/pari/unix/pari-2.3.5.tar.gz'
  homepage 'http://pari.math.u-bordeaux.fr/'
  md5 '6077c6db56fdd32e39a06a9bf320e1f7'

  def install
    system "./Configure", "--prefix=#{prefix}"
    system "make install"
  end
end
