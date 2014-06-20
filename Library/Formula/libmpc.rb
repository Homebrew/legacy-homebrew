require 'formula'

class Libmpc < Formula
  homepage 'http://multiprecision.org'
  url 'http://ftpmirror.gnu.org/mpc/mpc-1.0.2.tar.gz'
  mirror 'http://multiprecision.org/mpc/download/mpc-1.0.2.tar.gz'
  sha1 '5072d82ab50ec36cc8c0e320b5c377adb48abe70'

  bottle do
    cellar :any
    sha1 "e16e54c7407b4d69c60d984c5c3b5bd535f367e4" => :mavericks
    sha1 "432b857c0368882c21df2b92399ba2cb0e5c185c" => :mountain_lion
    sha1 "8b8959c9c098a1c96a4d017058cc792c6f19c00d" => :lion
  end

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
