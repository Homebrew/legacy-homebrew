require 'formula'

class Pari < Formula
  homepage 'http://pari.math.u-bordeaux.fr/'
  url 'http://pari.math.u-bordeaux.fr/pub/pari/unix/pari-2.5.4.tar.gz'
  sha1 '471226fd86fea0ad1f236249a49bdaee16aa34bf'

  depends_on 'readline'
  depends_on :x11

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
