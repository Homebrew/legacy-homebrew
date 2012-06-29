require 'formula'

class HttpLoad < Formula
  homepage 'http://www.acme.com/software/http_load/'
  url 'http://www.acme.com/software/http_load/http_load-12mar2006.tar.gz'
  md5 'd1a6c2261f8828a3f319e86ff0517219'
  version '20060312'

  def install
    bin.mkpath
    man1.mkpath
    args = %W[BINDIR=#{bin} LIBDIR=#{lib} MANDIR=#{man1} CC=#{ENV.cc} CFLAGS=#{ENV.cflags}]
    system "make", *args
    system "make", "install", *args
  end

  def test
    system "http_load"
  end
end
