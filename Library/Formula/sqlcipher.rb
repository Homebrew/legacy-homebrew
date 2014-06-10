require "formula"

class Sqlcipher < Formula
  homepage "http://sqlcipher.net"
  url "https://github.com/sqlcipher/sqlcipher/archive/v3.1.0.tar.gz"
  sha1 "350a7cbc01690825cb6beca3b9bf6943f71a52de"

  head "https://github.com/sqlcipher/sqlcipher.git"

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-tempstore=yes",
                          "CFLAGS=-DSQLITE_HAS_CODEC", "LDFLAGS=-lcrypto",
                          "--disable-tcl"
    system "make"
    system "make install"
  end
end
