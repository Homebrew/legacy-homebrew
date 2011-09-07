require 'formula'

class Libmemcached < Formula
  url 'http://launchpad.net/libmemcached/1.0/0.50/+download/libmemcached-0.50.tar.gz'
  homepage 'http://libmemcached.org'
  md5 'c8627014a37cd821cf93317b8de6f9f8'

  depends_on 'memcached'

  def install
    ENV.append_to_cflags "-undefined dynamic_lookup" if MacOS.leopard?

    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
