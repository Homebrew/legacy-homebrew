require 'formula'

class Libmicrohttpd < Formula
  homepage 'http://www.gnu.org/software/libmicrohttpd/'
  url 'http://ftpmirror.gnu.org/libmicrohttpd/libmicrohttpd-0.9.27.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.27.tar.gz'
  sha1 '430accec31334d49e2d6b4b9407a17576d5a6cd1'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
