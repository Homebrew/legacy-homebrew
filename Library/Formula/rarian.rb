require 'formula'

class Rarian < Formula
  url 'http://rarian.freedesktop.org/Releases/rarian-0.8.1.tar.bz2'
  homepage 'http://rarian.freedesktop.org/'
  md5 '75091185e13da67a0ff4279de1757b94'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
