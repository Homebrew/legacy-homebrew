require 'formula'

class Aget < Formula
  homepage 'http://www.enderunix.org/aget/'
  url 'http://www.enderunix.org/aget/aget-0.4.1.tar.gz'
  md5 'ddee95ad1d394a4751ebde24fcb36fa1'

  def patches
    { :p0 => "https://trac.macports.org/export/90173/trunk/dports/net/aget/files/patch-Head.c" }
  end

  def install
    system "make", "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "LDFLAGS=#{ENV.ldflags}"
    bin.install "aget"
    man1.install "aget.1"
  end
end
