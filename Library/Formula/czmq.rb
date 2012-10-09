require 'formula'

class Czmq < Formula
  homepage 'http://czmq.zeromq.org/'
  url 'http://download.zeromq.org/czmq-1.2.0.tar.gz'
  sha1 '826830df72443edb4646283cd5b490683af6df2a'

  option :universal

  depends_on 'zeromq'

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
