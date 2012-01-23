require 'formula'

class Libmemcached < Formula
  url 'http://launchpad.net/libmemcached/1.0/1.0.3/+download/libmemcached-1.0.3.tar.gz'
  homepage 'http://libmemcached.org'
  md5 '4b7d2b3cde72638b0cd4496cfc3ece14'

  depends_on 'memcached'

  def install
    ENV.append_to_cflags "-undefined dynamic_lookup" if MacOS.leopard?

    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
