require 'formula'

class HttpLoad < Formula
  homepage 'http://www.acme.com/software/http_load/'
  url 'http://www.acme.com/software/http_load/http_load-12mar2006.tar.gz'
  version '20060312'
  sha1 'a989253cf32f9ef038dfaa2c254773ea9912137f'

  def install
    bin.mkpath
    man1.mkpath
    args = %W[
      BINDIR=#{bin}
      LIBDIR=#{lib}
      MANDIR=#{man1}
      CC=#{ENV.cc}
      CFLAGS=#{ENV.cflags}
    ]
    system "make", *args
    system "make", "install", *args
  end
end
