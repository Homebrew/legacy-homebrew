require 'formula'

class Memcachedb < Formula
  url 'http://memcachedb.googlecode.com/files/memcachedb-1.2.1-beta.tar.gz'
  homepage 'http://memcachedb.org'
  md5 'd382839a96b0372b2d96418c5c9988e1'

  depends_on 'berkeley-db'
  depends_on 'libevent'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-threads"
    system "make install"
  end
end
