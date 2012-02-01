require 'formula'

class Czmq < Formula
  url 'http://download.zeromq.org/czmq-1.1.0.tar.gz'
  homepage 'http://czmq.zeromq.org/'
  md5 '8b057b08e34212138e81d3cd6dff127b'

  depends_on 'zeromq'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
