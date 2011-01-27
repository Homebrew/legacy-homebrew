require 'formula'

class Memcachedb <Formula
  url 'http://memcachedb.googlecode.com/files/memcachedb-1.2.0.tar.gz'
  homepage 'http://memcachedb.org'
  md5 '1642242ab2108611873588b77848317b'

  depends_on 'berkeley-db'
  depends_on 'libevent'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
