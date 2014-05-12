require 'formula'

class Libmpc < Formula
  homepage 'http://multiprecision.org'
  url 'ftp://ftp.gnu.org/gnu/mpc/mpc-1.0.2.tar.gz'
  sha1 '5072d82ab50ec36cc8c0e320b5c377adb48abe70'

  depends_on 'gmp'
  depends_on 'mpfr'

  def install
    args = [
      "--prefix=#{prefix}",
      "--disable-dependency-tracking",
      "--with-gmp=#{Formula["gmp"].opt_prefix}",
      "--with-mpfr=#{Formula["mpfr"].opt_prefix}"
    ]

    system "./configure", *args
    system "make"
    system "make check"
    system "make install"
  end
end
