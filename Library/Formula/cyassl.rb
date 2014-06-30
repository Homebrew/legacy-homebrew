require "formula"

class Cyassl < Formula
  homepage "http://yassl.com/yaSSL/Products-cyassl.html"
  url "https://github.com/cyassl/cyassl/archive/v3.0.2.tar.gz"
  sha256 "ff54f7fd319f358217f15fd2e1fcb56f00bf2050fb2ed3b699b83d62269c29ad"

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
