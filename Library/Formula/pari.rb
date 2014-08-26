require "formula"

class Pari < Formula
  homepage "http://pari.math.u-bordeaux.fr/"
  url "http://pari.math.u-bordeaux.fr/pub/pari/unix/pari-2.7.1.tar.gz"
  sha256 "cc637918f3c0b20dc9bbea99e639e7a288b89ea4d0e4e3f9b7110a115bcb41be"

  bottle do
    sha1 "7310d817b3aa680a0c52b742927a25d93657a49a" => :mavericks
    sha1 "d6862273809b309c03a869d3757a20612630de3c" => :mountain_lion
    sha1 "ef811fe6516c1e71c5b9142bbcff14ac4c86c6a5" => :lion
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
