require 'formula'

class Libssh2 <Formula
  url 'http://www.libssh2.org/download/libssh2-1.2.2.tar.gz'
  homepage 'http://www.libssh2.org/'
  md5 'fa8d9cd425bdd62f57244fc61fb54da7'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--with-openssl",
                          "--with-libz"
    system "make install"
  end
end
