require 'formula'

class Aria2 < Formula
  homepage 'http://aria2.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/aria2/stable/aria2-1.18.2/aria2-1.18.2.tar.bz2'
  sha1 '2f04a17567e6b793420a517b3fb0511f12c76289'

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

    ENV['ZLIB_CFLAGS'] = '-I/usr/include'
    ENV['ZLIB_LIBS'] = '-L/usr/lib -lz'

    system "./configure", *args
    system "make install"

    bash_completion.install "doc/bash_completion/aria2c"
  end
end
