require 'formula'

class Aria2 < Formula
  homepage 'http://aria2.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/aria2/stable/aria2-1.18.5/aria2-1.18.5.tar.bz2'
  sha1 '91639bf99a2e84873675f470fd36cee47f466770'

  bottle do
    cellar :any
    sha1 "33d1d04188a0da054cc3e2393b667f5cc232d9aa" => :mavericks
    sha1 "9606a416e16801fa2a4f857d00ebddcc3703e3d0" => :mountain_lion
    sha1 "6d10be34b7a6d03302b7119d5aa93959cb204d87" => :lion
  end

  depends_on 'pkg-config' => :build

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
    ENV['ZLIB_CFLAGS'] = '-I/usr/include'
    ENV['ZLIB_LIBS'] = '-L/usr/lib -lz'
    ENV['SQLITE3_CFLAGS'] = '-I/usr/include'
    ENV['SQLITE3_LIBS'] = '-L/usr/lib -lsqlite3'

    system "./configure", *args
    system "make install"

    bash_completion.install "doc/bash_completion/aria2c"
  end
end
