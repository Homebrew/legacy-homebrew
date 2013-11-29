require 'formula'

class Aria2 < Formula
  homepage 'http://aria2.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/aria2/stable/aria2-1.18.1/aria2-1.18.1.tar.bz2'
  sha1 '050f521848353fe90568059768d73a5a6f7ff869'

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
    system "./configure", *args
    system "make install"

    bash_completion.install "doc/bash_completion/aria2c"
  end
end
