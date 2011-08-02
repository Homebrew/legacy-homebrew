require 'formula'

class Libmicrohttpd < Formula
  url 'ftp://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.4.4.tar.gz'
  homepage 'http://www.gnu.org/software/libmicrohttpd/'
  md5 'bcd61ebb10286379f55c7db9c79e0465'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
