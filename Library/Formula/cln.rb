require 'formula'

class Cln < Formula
  homepage 'http://www.ginac.de/CLN/'
  url 'http://www.ginac.de/CLN/cln-1.3.2.tar.bz2'
  sha1 'c30dca80e75f45e2107f233075e6d0339ea884b0'

  depends_on "gmp"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--with-gmp=#{HOMEBREW_PREFIX}"
    system "make install"
  end
end
