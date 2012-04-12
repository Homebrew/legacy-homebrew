require 'formula'

class Cln < Formula
  url 'http://www.ginac.de/CLN/cln-1.3.2.tar.bz2'
  homepage 'http://www.ginac.de/CLN/'
  md5 'd897cce94d9c34d106575ed4ec865d71'

  depends_on "gmp"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--with-gmp=#{HOMEBREW_PREFIX}"
    system "make install"
  end
end
