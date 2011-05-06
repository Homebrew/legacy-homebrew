require 'formula'

class Libmicrohttpd < Formula
  url 'ftp://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.10.tar.gz'
  homepage 'http://www.gnu.org/software/libmicrohttpd/'
  md5 '7cc44373fe1b03348510755839091578'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
