require 'formula'

class Libmicrohttpd < Formula
  homepage 'http://www.gnu.org/software/libmicrohttpd/'
  url 'http://ftpmirror.gnu.org/libmicrohttpd/libmicrohttpd-0.9.34.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.34.tar.gz'
  sha1 '1122f26fa278556630aaef40a500a9be19bdcfc9'

  bottle do
    cellar :any
    sha1 "9b6bb328687843151b8cd4222dc81db7c487cfd2" => :mavericks
    sha1 "68832916795813e9ffa00e459c44be76b8bba21a" => :mountain_lion
    sha1 "1ed41f9ee7101988beec5577c3c91e22d1ccfef8" => :lion
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
