require 'formula'

class Libssh2 < Formula
  url 'http://www.libssh2.org/download/libssh2-1.3.0.tar.gz'
  homepage 'http://www.libssh2.org/'
  md5 '6425331899ccf1015f1ed79448cb4709'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--with-openssl",
                          "--with-libz"
    system "make install"
  end
end
