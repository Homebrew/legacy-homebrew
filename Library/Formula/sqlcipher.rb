require "formula"

class Sqlcipher < Formula
  homepage "http://sqlcipher.net"
  head "https://github.com/sqlcipher/sqlcipher.git"
  url "https://github.com/sqlcipher/sqlcipher/archive/v3.1.0.tar.gz"
  sha1 "350a7cbc01690825cb6beca3b9bf6943f71a52de"

  option 'with-fts', 'Build with full-text search enabled'

  depends_on "openssl"

  option "with-fts", "Build with full-text search enabled"

  depends_on "openssl"

  def install

    args = %W[
      --prefix=#{prefix}
      --enable-tempstore=yes
      --with-crypto-lib=#{Formula["openssl"].opt_prefix}
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
