require 'formula'

class Libmpc < Formula
  homepage 'http://multiprecision.org'
  url 'http://multiprecision.org/mpc/download/mpc-1.0.1.tar.gz'
  sha1 '8c7e19ad0dd9b3b5cc652273403423d6cf0c5edf'

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
