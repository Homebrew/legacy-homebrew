require 'formula'

class Libmemcached < Formula
  homepage 'http://libmemcached.org'
  url 'https://launchpad.net/libmemcached/1.0/1.0.16/+download/libmemcached-1.0.16.tar.gz'
  sha1 '6edf8dfde99af0aa0f2acc084c18682bde7c197c'

  depends_on 'memcached'

  def install
    ENV.append_to_cflags "-undefined dynamic_lookup" if MacOS.version == :leopard

    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
