require 'formula'

class Nettle < Formula
  homepage 'http://www.lysator.liu.se/~nisse/nettle/'
  url 'http://www.lysator.liu.se/~nisse/archive/nettle-2.6.tar.gz'
  sha1 '401f982a0b365e04c8c38c4da42afdd7d2d51d80'

  depends_on 'gmp'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-shared"
    system "make"
    system "make install"
    system "make check"
  end
end
