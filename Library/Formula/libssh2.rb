require 'brewkit'

class Libssh2 <Formula
  url 'http://www.libssh2.org/download/libssh2-1.2.1.tar.gz'
  homepage 'http://www.libssh2.org/'
  md5 '4ee0197947a3b8a4472328c346e1a0e4'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--with-openssl",
                          "--with-libz"
    system "make install"
  end
end
