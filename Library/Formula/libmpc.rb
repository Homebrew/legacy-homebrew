require 'formula'

class Libmpc < Formula
  homepage 'http://multiprecision.org'
  url 'http://ftpmirror.gnu.org/mpc/mpc-1.0.2.tar.gz'
  mirror 'http://multiprecision.org/mpc/download/mpc-1.0.2.tar.gz'
  sha1 '5072d82ab50ec36cc8c0e320b5c377adb48abe70'

  bottle do
    cellar :any
    revision 1
    sha1 '491bd8e7535792094846c22c97284c9a9d77eb11' => :mavericks
    sha1 '129f7b22a326fa10d6ded3aa1059aa4c0b31b673' => :mountain_lion
    sha1 '533355b4698b5964cad3bca1268a913c5a9a76b2' => :lion
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
