require 'formula'

class Cln < Formula
  homepage 'http://www.ginac.de/CLN/'
  url 'http://www.ginac.de/CLN/cln-1.3.3.tar.bz2'
  sha1 '11c56780eb83ed54f2ad1ecef7f0dc0f609c426d'

  depends_on "gmp"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--with-gmp=#{HOMEBREW_PREFIX}"
    system "make install"
  end
end
