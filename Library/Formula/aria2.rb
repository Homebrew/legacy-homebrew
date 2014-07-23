require "formula"

class Aria2 < Formula
  homepage "http://aria2.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/aria2/stable/aria2-1.18.6/aria2-1.18.6.tar.bz2"
  sha1 "348c0e6150218768901b0cbf94300a52c4e86864"

  bottle do
    cellar :any
    sha1 "935615bcfa8c92272b5ef4481e3313d2474d5c05" => :mavericks
    sha1 "76a2a01d4b0dbce3410d29bb9c3c3caaf3110e78" => :mountain_lion
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
