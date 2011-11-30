require 'formula'

class Pari < Formula
  url 'http://pari.math.u-bordeaux.fr/pub/pari/unix/pari-2.5.0.tar.gz'
  homepage 'http://pari.math.u-bordeaux.fr/'
  md5 '0b595a1345679ff482785a686c863e9f'

  def install
    system "./Configure", "--prefix=#{prefix}"
    # make needs to be done in two steps
    system "make all"
    system "make install"
  end
end
