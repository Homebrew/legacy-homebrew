require 'formula'

class Libmpc < Formula
  url 'http://multiprecision.org/mpc/download/mpc-0.9.tar.gz'
  homepage 'http://multiprecision.org'
  md5 '0d6acab8d214bd7d1fbbc593e83dd00d'

  depends_on 'gmp'
  depends_on 'mpfr'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
