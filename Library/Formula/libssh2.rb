require 'formula'

class Libssh2 < Formula
  url 'http://www.libssh2.org/download/libssh2-1.2.8.tar.gz'
  homepage 'http://www.libssh2.org/'
  md5 '1b236563b75d1b1f0d483352dc5918cf'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--with-openssl",
                          "--with-libz"
    system "make install"
  end
end
