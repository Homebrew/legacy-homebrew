require 'formula'

class Aget < Formula
  homepage 'http://www.enderunix.org/aget/'
  url 'http://www.enderunix.org/aget/aget-0.4.1.tar.gz'
  sha1 '6f7bc1676fd506207a1a168c587165b902d9d609'

  patch :p0 do
    url "https://trac.macports.org/export/90173/trunk/dports/net/aget/files/patch-Head.c"
    sha1 "03999e0c23259ec0ed849e8e0e7e2b16b28a1387"
  end

  def install
    system "make", "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "LDFLAGS=#{ENV.ldflags}"
    bin.install "aget"
    man1.install "aget.1"
  end
end
