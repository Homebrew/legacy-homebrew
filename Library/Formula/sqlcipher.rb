require 'formula'

class Sqlcipher < Formula
  homepage "http://sqlcipher.net"
  url 'https://github.com/sqlcipher/sqlcipher/archive/v3.0.0.tar.gz'
  sha1 '7069b9ff8136de053693e018a58f59f118fcfe77'

  head "https://github.com/sqlcipher/sqlcipher.git"

  keg_only "SQLCipher conflicts with the system and Homebrew SQLites."

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-tempstore=yes",
                          "CFLAGS=-DSQLITE_HAS_CODEC", "LDFLAGS=-lcrypto",
                          "--disable-tcl"
    system "make"
    system "make install"
  end
end
