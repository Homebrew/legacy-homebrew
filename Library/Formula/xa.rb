require 'formula'

class Xa < Formula
  homepage 'http://www.floodgap.com/retrotech/xa/'
  url 'http://www.floodgap.com/retrotech/xa/dists/xa-2.3.5.tar.gz'
  sha1 'd8f4564953adfcee69faacfa300b954875fabe21'

  def install
    system "make", "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "DESTDIR=#{prefix}",
                   "install"
  end
end
