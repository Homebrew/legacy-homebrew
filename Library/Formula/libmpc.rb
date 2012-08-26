require 'formula'

class Libmpc < Formula
  homepage 'http://multiprecision.org'
  url 'http://multiprecision.org/mpc/download/mpc-1.0.tar.gz'
  sha1 '20af7cc481433c019285a2c1757ac65e244e1e06'

  depends_on 'gmp'
  depends_on 'mpfr'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make check"
    system "make install"
  end
end
