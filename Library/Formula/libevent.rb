require 'formula'

class Libevent <Formula
  version '1.4.13'
  url "http://www.monkey.org/~provos/libevent-#{@version}-stable.tar.gz"
  homepage 'http://www.monkey.org/~provos/libevent/'
  md5 '0b3ea18c634072d12b3c1ee734263664'

  def install
    ENV.j1 # Needed for Mac Pro compilation
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
