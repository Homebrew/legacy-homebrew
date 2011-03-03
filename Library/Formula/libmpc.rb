require 'formula'

class Libmpc < Formula
  url 'http://multiprecision.org/mpc/download/mpc-0.8.2.tar.gz'
  homepage 'http://multiprecision.org'
  md5 'e98267ebd5648a39f881d66797122fb6'

  depends_on 'gmp'
  depends_on 'mpfr'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
