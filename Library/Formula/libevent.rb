require 'formula'

class Libevent <Formula
  version '1.4.13'
  url "http://www.monkey.org/~provos/libevent-#{@version}-stable.tar.gz"
  homepage 'http://www.monkey.org/~provos/libevent/'
  md5 '0b3ea18c634072d12b3c1ee734263664'
  head 'git://levent.git.sourceforge.net/gitroot/levent/levent'

  def install
    system "./autogen.sh" if ARGV.include? '--HEAD'

    ENV.j1 # Needed for Mac Pro compilation
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
