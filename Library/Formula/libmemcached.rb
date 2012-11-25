require 'formula'

class Libmemcached < Formula
  homepage 'http://libmemcached.org'
  url 'https://launchpad.net/libmemcached/1.0/1.0.14/+download/libmemcached-1.0.14.tar.gz'
  md5 '3b074b9e23e07fe8fbb85ba5f952f62c'

  depends_on 'memcached'

  def install
    ENV.append_to_cflags "-undefined dynamic_lookup" if MacOS.version == :leopard

    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
