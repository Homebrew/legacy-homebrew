require 'formula'

class Aria2 < Formula
  homepage 'http://aria2.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/aria2/stable/aria2-1.18.3/aria2-1.18.3.tar.bz2'
  sha1 '1a0b42e69b49fa9efb624ba2ba86118f0fb77aef'

  depends_on 'pkg-config' => :build
  depends_on :macos => :lion # Needs a c++11 compiler

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
    ENV['ZLIB_CFLAGS'] = '-I/usr/include'
    ENV['ZLIB_LIBS'] = '-L/usr/lib -lz'
    ENV['SQLITE3_CFLAGS'] = '-I/usr/include'
    ENV['SQLITE3_LIBS'] = '-L/usr/lib -lsqlite3'

    system "./configure", *args
    system "make install"

    bash_completion.install "doc/bash_completion/aria2c"
  end
end
