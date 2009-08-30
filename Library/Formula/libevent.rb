require 'brewkit'

class Libevent <Formula
  @version='1.4.12'
  @url="http://www.monkey.org/~provos/libevent-#{@version}-stable.tar.gz"
  @homepage='http://www.monkey.org/~provos/libevent/'
  @md5='77b0d8b9885496871bb083165b35ba11'

  def install
    system "./configure --prefix='#{prefix}'"
    system "make install"
  end
end
