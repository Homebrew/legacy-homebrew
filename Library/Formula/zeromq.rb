require 'formula'

class Zeromq <Formula
  url 'http://www.zeromq.org/local--files/area:download/zeromq-2.0.6.tar.gz'
  homepage 'http://www.zeromq.org/'
  md5 'ffb5d724d1400550a12c81dd81874892'
  
  aka '0mq'
  aka 'zmq'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
