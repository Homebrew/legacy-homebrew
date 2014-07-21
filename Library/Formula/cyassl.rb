require "formula"

class Cyassl < Formula
  homepage "http://yassl.com/yaSSL/Products-cyassl.html"
  url "https://github.com/cyassl/cyassl/archive/v3.1.0.tar.gz"
  sha256 "8ece90d145255e6be5934829d86497d2425e2220d9a622d3aa08e5d965fa8d9a"

  head "https://github.com/cyassl/cyassl.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    args = %W[--infodir=#{info}
              --mandir=#{man}
              --prefix=#{prefix}
              --disable-bump
              --disable-fortress
              --disable-ntru
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
