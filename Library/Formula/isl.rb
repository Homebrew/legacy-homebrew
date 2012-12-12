require 'formula'

class Isl < Formula
  homepage 'http://www.kotnet.org/~skimo/isl/'
  url 'http://www.kotnet.org/~skimo/isl/isl-0.10.tar.bz2'
  mirror 'ftp://gcc.gnu.org/pub/gcc/infrastructure/isl-0.10.tar.bz2'
  sha1 '91db73f10075a67039c38abfcd5b1bd64581a6e3'

  head 'http://repo.or.cz/w/isl.git'

  depends_on 'gmp'

  def install
    args = [
      "--disable-dependency-tracking",
      "--prefix=#{prefix}",
    ]

    system "./configure", *args
    system "make install"
  end
end
