require "formula"

class Aria2 < Formula
  homepage "http://aria2.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/aria2/stable/aria2-1.18.8/aria2-1.18.8.tar.bz2"
  sha1 "b6ad7064b1ea769e78f6a7dc9787a12cfc1e153f"

  bottle do
    cellar :any
    sha1 "1836e8382c9f6e9a1893d8700b74b48f8b98385b" => :mavericks
    sha1 "ab16e0ccfbb1aee0252d77d67b61842503affee7" => :mountain_lion
    sha1 "178a5ec35b34814fa054d4a2e97ba600c8cb353f" => :lion
  end

  depends_on "pkg-config" => :build

  needs :cxx11

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-appletls
      --without-openssl
      --without-gnutls
      --without-libgmp
      --without-libnettle
      --without-libgcrypt
    ]

    # system zlib and sqlite don't include .pc files
    ENV["ZLIB_CFLAGS"] = "-I/usr/include"
    ENV["ZLIB_LIBS"] = "-L/usr/lib -lz"
    ENV["SQLITE3_CFLAGS"] = "-I/usr/include"
    ENV["SQLITE3_LIBS"] = "-L/usr/lib -lsqlite3"

    system "./configure", *args
    system "make install"

    bash_completion.install "doc/bash_completion/aria2c"
  end
end
