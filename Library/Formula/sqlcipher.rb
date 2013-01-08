require 'formula'

class Sqlcipher < Formula
  head "https://github.com/sqlcipher/sqlcipher.git"
  homepage "http://sqlcipher.net"
  url "https://github.com/sqlcipher/sqlcipher/archive/v2.1.1.tar.gz"
  sha1 "032110255562e9ada5f31078dc8426441a47a7ce"
  keg_only :provided_by_osx, "The binary provided by OS X does not support encrypted databases."
  
  def install
    args = ["--enable-tempstore=yes",
            "--disable-tcl",
            "CFLAGS=-DSQLITE_HAS_CODEC",
            "LDFLAGS=-lcrypto",
            "--prefix=#{prefix}"]

    system "./configure", *args
    system "make"
    system "make install"
  end
end
