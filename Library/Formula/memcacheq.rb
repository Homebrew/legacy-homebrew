require 'formula'

class Memcacheq < Formula
  homepage 'http://memcachedb.org/memcacheq'
  url 'https://memcacheq.googlecode.com/files/memcacheq-0.2.0.tar.gz'
  sha1 'fc373e02335301cbfe4c00420bdf8592ca2bf95a'

  depends_on 'berkeley-db'
  depends_on 'libevent'

  def install
    ENV.append 'CFLAGS', '-std=gnu89'
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-threads"
    system "make install"
  end
end
