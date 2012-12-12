require 'formula'

class Memcacheq < Formula
  url 'http://memcacheq.googlecode.com/files/memcacheq-0.2.0.tar.gz'
  homepage 'http://memcachedb.org/memcacheq'
  sha1 'fc373e02335301cbfe4c00420bdf8592ca2bf95a'

  depends_on 'berkeley-db'
  depends_on 'libevent'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-threads"
    system "make install"
  end
end
