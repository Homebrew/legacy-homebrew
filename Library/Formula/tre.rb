require 'formula'

class Tre < Formula
  homepage 'http://laurikari.net/tre/'
  url 'http://laurikari.net/tre/tre-0.8.0.tar.bz2'
  sha1 'a41692e64b40ebae3cffe83931ddbf8420a10ae3'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
