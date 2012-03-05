require 'formula'

class Libmemcached < Formula
  homepage 'http://libmemcached.org'
  url 'http://launchpad.net/libmemcached/1.0/1.0.4/+download/libmemcached-1.0.4.tar.gz'
  md5 '6eded403ce736f6ac3c42c8f54dc88ae'

  depends_on 'memcached'

  def install
    ENV.append_to_cflags "-undefined dynamic_lookup" if MacOS.leopard?

    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
