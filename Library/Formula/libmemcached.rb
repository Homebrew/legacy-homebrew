require 'formula'

class Libmemcached < Formula
  homepage 'http://libmemcached.org'
  url 'http://launchpad.net/libmemcached/1.0/1.0.8/+download/libmemcached-1.0.8.tar.gz'
  sha1 'ac1925aea002d8ad28d709aa374d057c73e322af'

  depends_on 'memcached'

  def install
    ENV.append_to_cflags "-undefined dynamic_lookup" if MacOS.leopard?

    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
