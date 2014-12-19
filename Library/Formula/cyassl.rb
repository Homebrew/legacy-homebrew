require "formula"

class Cyassl < Formula
  homepage "http://yassl.com/yaSSL/Products-cyassl.html"
  url "https://github.com/cyassl/cyassl/archive/v3.3.0.tar.gz"
  sha256 "585ca95b23a44da2d0e042bd0aef95ce770cd541028b76dc45f29ab62ad3ad4a"

  head "https://github.com/cyassl/cyassl.git"

  bottle do
    cellar :any
    sha1 "47a068ee29646ef26b3f7e2a62268f62ed73dbec" => :yosemite
    sha1 "57f47edc303e4f7f07d893a0724c67e068ca4883" => :mavericks
    sha1 "c5de09829f89696a73a8f3818bbf413eae99e5ac" => :mountain_lion
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
