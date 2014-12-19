require "formula"

class Sqlcipher < Formula
  homepage "http://sqlcipher.net"
  url "https://github.com/sqlcipher/sqlcipher/archive/v3.2.0.tar.gz"
  sha1 "44af36d34f05154a7527a55389d9bc0ef0913595"

  head "https://github.com/sqlcipher/sqlcipher.git"

  option "with-fts", "Build with full-text search enabled"

  depends_on "openssl"

  def install

    args = %W[
      --prefix=#{prefix}
      --enable-tempstore=yes
      --with-crypto-lib=#{Formula["openssl"].opt_prefix}
      --enable-load-extension
      --disable-tcl
    ]

    if build.with?("fts")
      args << "CFLAGS=-DSQLITE_HAS_CODEC -DSQLITE_ENABLE_FTS3"
    else
      args << "CFLAGS=-DSQLITE_HAS_CODEC"
    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end
end
