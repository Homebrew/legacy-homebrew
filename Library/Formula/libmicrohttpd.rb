require 'formula'

class Libmicrohttpd < Formula
  homepage 'http://www.gnu.org/software/libmicrohttpd/'
  url 'http://ftpmirror.gnu.org/libmicrohttpd/libmicrohttpd-0.9.34.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.34.tar.gz'
  sha1 '1122f26fa278556630aaef40a500a9be19bdcfc9'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
