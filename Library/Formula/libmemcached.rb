require 'formula'

class Libmemcached <Formula
  url 'http://download.tangent.org/libmemcached-0.34.tar.gz'
  homepage 'http://tangent.org/552/libmemcached.html'
  md5 '5b2026bc0c324066f5175543306d941b'

  depends_on 'memcached'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end