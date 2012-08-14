require 'formula'

class Rarian < Formula
  homepage 'http://rarian.freedesktop.org/'
  url 'http://rarian.freedesktop.org/Releases/rarian-0.8.1.tar.bz2'
  md5 '75091185e13da67a0ff4279de1757b94'

  conflicts_with 'scrollkeeper',
    :because => "rarian and scrollkeeper install the same binaries."

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
