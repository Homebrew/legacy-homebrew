require 'formula'

class Libssh2 < Formula
  url 'http://www.libssh2.org/download/libssh2-1.2.7.tar.gz'
  homepage 'http://www.libssh2.org/'
  md5 'a5d78344886f1282e4008c09bf568076'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--with-openssl",
                          "--with-libz"
    system "make install"
  end
end
