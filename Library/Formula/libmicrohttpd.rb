require 'formula'

class Libmicrohttpd < Formula
  url 'http://ftpmirror.gnu.org/libmicrohttpd/libmicrohttpd-0.9.13.tar.gz'
  homepage 'http://www.gnu.org/software/libmicrohttpd/'
  md5 'f826b70228cb0987c56515436a8e0fd7'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
