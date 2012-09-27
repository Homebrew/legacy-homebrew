require 'formula'

class Pari < Formula
  homepage 'http://pari.math.u-bordeaux.fr/'
  url 'http://pari.math.u-bordeaux.fr/pub/pari/unix/pari-2.5.1.tar.gz'
  sha1 'c83314bb993161a60e1e46ae7616072858414354'

  depends_on 'readline'

  def install
    readline = Formula.factory 'readline'
    system "./Configure", "--prefix=#{prefix}",
                          "--with-readline-include=#{readline.include}",
                          "--with-readline-lib=#{readline.lib}"
    # make needs to be done in two steps
    system "make all"
    system "make install"
  end
end
