require 'formula'

class Czmq < Formula
  url 'https://github.com/zeromq/czmq/zipball/v1.0.0'
  homepage 'https://github.com/zeromq/czmq'
  md5 'acab94c54c1c1f9b4be6157c4c9ffd1a'
  head 'https://github.com/zeromq/czmq.git'

  depends_on 'zeromq'

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
