require 'formula'

class Memcacheq <Formula
  url 'http://memcacheq.googlecode.com/files/memcacheq-0.2.0.tar.gz'
  homepage 'http://memcachedb.org/memcacheq'
  md5 'feab28f4cd4dd37311c98df6e14ea997'

  depends_on 'berkeley-db'
  depends_on 'libevent'

  def install
    system "./configure", "--disable-debug", "--enable-threads", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
