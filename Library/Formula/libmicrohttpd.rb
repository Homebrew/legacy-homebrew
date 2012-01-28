require 'formula'

class Libmicrohttpd < Formula
  url 'http://ftpmirror.gnu.org/libmicrohttpd/libmicrohttpd-0.9.15.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.15.tar.gz'
  homepage 'http://www.gnu.org/software/libmicrohttpd/'
  md5 'fb726a48095cc6b25c245dbc27ea76b0'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
