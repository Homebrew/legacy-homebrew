require "formula"

class Aria2 < Formula
  homepage "http://aria2.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/aria2/stable/aria2-1.18.8/aria2-1.18.8.tar.bz2"
  sha1 "b6ad7064b1ea769e78f6a7dc9787a12cfc1e153f"

  bottle do
    cellar :any
    sha1 "0d9ea391b7e7651df5abd4fb4e7eabd45e6e3d48" => :mavericks
    sha1 "6be677ac2eefae9f5e658f3e340864d53ffb5f8b" => :mountain_lion
    sha1 "b2aff43e5bffe9fe203b23e05060cc84944c20c0" => :lion
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
