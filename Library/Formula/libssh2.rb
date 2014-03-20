require 'formula'

class Libssh2 < Formula
  homepage 'http://www.libssh2.org/'
  url 'http://www.libssh2.org/download/libssh2-1.4.3.tar.gz'
  sha1 'c27ca83e1ffeeac03be98b6eef54448701e044b0'

  bottle do
  end

  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--with-openssl",
                          "--with-libssl-prefix=#{Formula['openssl'].opt_prefix}",
                          "--with-libz"
    system "make install"
  end
end
