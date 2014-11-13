require "formula"

class Pari < Formula
  homepage "http://pari.math.u-bordeaux.fr/"
  url "http://pari.math.u-bordeaux.fr/pub/pari/unix/pari-2.7.2.tar.gz"
  sha256 "ac76c99549d549273087daa554c4dabaf9239881da422f69acb05fa7a0ff10ac"

  bottle do
    sha1 "279df09e4ed8ef338a908d22b376be54de33900c" => :mavericks
    sha1 "e7fba0b065c31e7f9b23d198f24f76333d28a8ba" => :mountain_lion
    sha1 "8dcd6a003063962867a9f29830acd6eeea58e90f" => :lion
  end

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
