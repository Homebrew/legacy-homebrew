require 'brewkit'

class Memcached <Formula
  @url='http://memcached.googlecode.com/files/memcached-1.4.0.tar.gz'
  @homepage='http://www.danga.com/memcached/'
  @md5='d7651ecb8bf345144cb17900d9a46c85'

  depends_on 'libevent'

  def install
    system "./configure --prefix='#{prefix}'"
    system "make install"
  end
end
