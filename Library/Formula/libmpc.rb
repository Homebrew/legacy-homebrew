require 'formula'

class Libmpc < Formula
  homepage 'http://multiprecision.org'
  url 'http://ftpmirror.gnu.org/mpc/mpc-1.0.2.tar.gz'
  mirror 'http://multiprecision.org/mpc/download/mpc-1.0.2.tar.gz'
  sha1 '5072d82ab50ec36cc8c0e320b5c377adb48abe70'

  bottle do
    cellar :any
    revision 2
    sha1 "656a38feba0a27261f7e71060449731f3e18f7ee" => :yosemite
    sha1 "0f02ce11ca69a24e02e2abd08b01b48192cdac59" => :mavericks
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
