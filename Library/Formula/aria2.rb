require 'formula'

class Aria2 < Formula
  homepage 'http://aria2.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/aria2/stable/aria2-1.18.4/aria2-1.18.4.tar.bz2'
  sha1 '389829028d8e95f08d42a3bef00ab3237a4b246f'

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
