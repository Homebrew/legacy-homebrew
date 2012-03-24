require 'formula'

class Xa < Formula
  homepage 'http://www.floodgap.com/retrotech/xa/'
  url 'http://www.floodgap.com/retrotech/xa/dists/xa-2.3.5.tar.gz'
  md5 'edd15aa8674fb86225faf34e56d5cab2'

  def install
    system "make", "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "DESTDIR=#{prefix}",
                   "install"
  end
end
