require 'formula'

class Cln < Formula
  homepage 'http://www.ginac.de/CLN/'
  url 'http://www.ginac.de/CLN/cln-1.3.3.tar.bz2'
  sha1 '11c56780eb83ed54f2ad1ecef7f0dc0f609c426d'

  depends_on 'gmp'

  # Patch for Clang from MacPorts
  patch do
    url "https://trac.macports.org/export/114806/trunk/dports/math/cln/files/patch-clang.diff"
    sha1 "0e95e34b7b821fe8ddfc04c099cf5b9d72fc9093"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--with-gmp=#{HOMEBREW_PREFIX}"
    system "make install"
  end
end
