require 'formula'

class Sqlcipher < Formula
  homepage 'http://sqlcipher.net'
  url 'https://github.com/sqlcipher/sqlcipher/tarball/v2.0.5'
  md5 '49f365c2c751bfc7708f7943f4a27e29'
  version '2.0.5'
  head 'https://github.com/sqlcipher/sqlcipher.git'

  depends_on 'sqlite'

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-tempstore=yes", "--disable-tcl", "CFLAGS=-DSQLITE_HAS_CODEC", "LDFLAGS=-lcrypto"
    system "make"
    system "make install"
  end
end