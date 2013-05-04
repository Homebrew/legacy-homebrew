require 'formula'

class Libmicrohttpd < Formula
  homepage 'http://www.gnu.org/software/libmicrohttpd/'
  url 'http://ftpmirror.gnu.org/libmicrohttpd/libmicrohttpd-0.9.26.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.26.tar.gz'
  sha1 'b6869fa5274d846b6325f205c023d7e2bd31f7f5'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
