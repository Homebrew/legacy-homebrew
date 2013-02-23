require 'formula'

class Rarian < Formula
  homepage 'http://rarian.freedesktop.org/'
  url 'http://rarian.freedesktop.org/Releases/rarian-0.8.1.tar.bz2'
  sha1 '9b3f1bad1cdbb0de51d6f74431b20eb3647edc5a'

  conflicts_with 'scrollkeeper',
    :because => "rarian and scrollkeeper install the same binaries."

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
