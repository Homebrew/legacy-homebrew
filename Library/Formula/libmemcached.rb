require 'formula'

class Libmemcached < Formula
  homepage 'http://libmemcached.org'
  url 'https://launchpad.net/libmemcached/1.0/1.0.17/+download/libmemcached-1.0.17.tar.gz'
  sha1 '1023bc8c738b1f5b8ea2cd16d709ec6b47c3efa8'

  depends_on 'memcached'

  def install
    ENV.append_to_cflags "-undefined dynamic_lookup" if MacOS.version <= :leopard

    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
