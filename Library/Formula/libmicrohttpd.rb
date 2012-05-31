require 'formula'

class Libmicrohttpd < Formula
  homepage 'http://www.gnu.org/software/libmicrohttpd/'
  url 'http://ftpmirror.gnu.org/libmicrohttpd/libmicrohttpd-0.9.20.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.20.tar.gz'
  md5 'ede6ad4a07a8a0794c42e4ef356ee27c'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
