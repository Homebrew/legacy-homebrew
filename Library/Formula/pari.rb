require 'formula'

class Pari < Formula
  homepage 'http://pari.math.u-bordeaux.fr/'
  url 'http://pari.math.u-bordeaux.fr/pub/pari/unix/pari-2.5.3.tar.gz'
  sha1 'de79eee7ae017a495dc0c648b6f7d5a4f6c7a522'

  depends_on 'readline'

  def install
    readline = Formula.factory 'readline'
    system "./Configure", "--prefix=#{prefix}",
                          "--without-gmp",
                          "--with-readline-include=#{readline.include}",
                          "--with-readline-lib=#{readline.lib}"
    # make needs to be done in two steps
    system "make all"
    system "make install"
  end
end
