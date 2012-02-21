require 'formula'

class Pari < Formula
  url 'http://pari.math.u-bordeaux.fr/pub/pari/unix/pari-2.5.1.tar.gz'
  homepage 'http://pari.math.u-bordeaux.fr/'
  md5 'd267dd1be4839f209217c8fff615478e'
  depends_on 'readline' => :optional

  def install
    system("./Configure", "--prefix=#{prefix}", 
      "--with-readline-include=#{Formula.factory('readline').include}",
      "--with-readline-lib=#{Formula.factory('readline').lib}")
    # make needs to be done in two steps
    system "make all"
    system "make install"
  end
end
