require "formula"

class Cyassl < Formula
  homepage "http://yassl.com/yaSSL/Products-cyassl.html"
  url "https://github.com/cyassl/cyassl/archive/v3.2.0.tar.gz"
  sha256 "4b82b6cd54aec42abc557e7dc3ec8239867c5373166b9346998fbe1232b3177c"

  head "https://github.com/cyassl/cyassl.git"

  bottle do
    cellar :any
    sha1 "af3935e69de8e276da44489ee06d7bd02f12d611" => :mavericks
    sha1 "3d46f2e384ded4b9d1fd6854ea9f5b45a2582e6b" => :mountain_lion
    sha1 "3d3bae7a0f09f77cad6219b75ca9193fe5931bda" => :lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    args = %W[--infodir=#{info}
              --mandir=#{man}
              --prefix=#{prefix}
              --disable-bump
              --disable-fortress
              --disable-sniffer
              --disable-webserver
              --enable-aesccm
              --enable-aesgcm
              --enable-blake2
              --enable-camellia
              --enable-certgen
              --enable-crl
              --enable-crl-monitor
              --enable-dtls
              --enable-ecc
              --enable-filesystem
              --enable-hc128
              --enable-inline
              --enable-keygen
              --enable-md4
              --enable-ocsp
              --enable-opensslextra
              --enable-psk
              --enable-rabbit
              --enable-ripemd
              --enable-sha512
              --enable-sni
    ]

    if MacOS.prefer_64_bit?
      args << "--enable-fastmath" << "--enable-fasthugemath"
    else
      args << "--disable-fastmath" << "--disable-fasthugemath"
    end

    # Extra flag is stated as a needed for the Mac platform.
    # http://yassl.com/yaSSL/Docs-cyassl-manual-2-building-cyassl.html
    # Also, only applies if fastmath is enabled.
    ENV.append_to_cflags "-mdynamic-no-pic" if MacOS.prefer_64_bit?

    system "./autogen.sh"
    system "./configure", *args
    system "make"
    system "make install"
  end
end
