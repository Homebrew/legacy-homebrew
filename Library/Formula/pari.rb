require "formula"

class Pari < Formula
  homepage "http://pari.math.u-bordeaux.fr/"
  url "http://pari.math.u-bordeaux.fr/pub/pari/unix/pari-2.5.5.tar.gz"
  sha1 "77637f935ee4a3b78e7015cef00146bd2f7e96bc"

  depends_on "gmp"
  depends_on "readline"
  depends_on :x11

  def install
    readline = Formula["readline"].opt_prefix
    gmp = Formula["gmp"].opt_prefix
    system "./Configure", "--prefix=#{prefix}",
                          "--with-gmp=#{gmp}",
                          "--with-readline=#{readline}"
    # make needs to be done in two steps
    system "make all"
    system "make install"
  end
end
