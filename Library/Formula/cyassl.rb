class Cyassl < Formula
  desc "Embedded SSL Library written in C"
  homepage "http://www.wolfssl.com/yaSSL/Home.html"
  url "https://github.com/wolfSSL/wolfssl/archive/v3.4.0.tar.gz"
  sha256 "e23b7939c04bf18efa353ff9abfeaba3bcf454e47c9ced45e2aadab6660245f0"
  head "https://github.com/wolfSSL/wolfssl.git"

  bottle do
    cellar :any
    sha256 "17893cd56326d12cb3c8d0d7158255ad7ca5df30e5fa160b0309e8ab6805eaa8" => :yosemite
    sha256 "452f4d57bbba4f48c9e148c5c4311236143d5f15933051d5bae6f5148ffd427f" => :mavericks
    sha256 "3eeb925899dd6b339a1eb4d3f303e3bf628fa25dc6e5b93a2ed7bd079a2d4195" => :mountain_lion
  end

  option "without-check", "Skip compile-time tests."

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    # At some point it'd be nice to be able to "--disable-md5" but:
    # https://github.com/wolfSSL/wolfssl/issues/26
    args = %W[
      --disable-silent-rules
      --disable-dependency-tracking
      --infodir=#{info}
      --mandir=#{man}
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --disable-bump
      --disable-examples
      --disable-fortress
      --disable-sniffer
      --disable-webserver
      --enable-aesccm
      --enable-aesgcm
      --enable-blake2
      --enable-camellia
      --enable-certgen
      --enable-certreq
      --enable-chacha
      --enable-crl
      --enable-crl-monitor
      --enable-dtls
      --enable-dh
      --enable-ecc
      --enable-eccencrypt
      --enable-ecc25519
      --enable-filesystem
      --enable-hc128
      --enable-hkdf
      --enable-inline
      --enable-keygen
      --enable-ocsp
      --enable-opensslextra
      --enable-poly1305
      --enable-psk
      --enable-rabbit
      --enable-ripemd
      --enable-savesession
      --enable-savecert
      --enable-sessioncerts
      --enable-sha512
      --enable-sni
      --enable-supportedcurves
    ]

    if MacOS.prefer_64_bit?
      args << "--enable-fastmath" << "--enable-fasthugemath"
    else
      args << "--disable-fastmath" << "--disable-fasthugemath"
    end

    args << "--enable-aesni" if Hardware::CPU.aes? && !build.bottle?

    # Extra flag is stated as a needed for the Mac platform.
    # http://yassl.com/yaSSL/Docs-cyassl-manual-2-building-cyassl.html
    # Also, only applies if fastmath is enabled.
    ENV.append_to_cflags "-mdynamic-no-pic" if MacOS.prefer_64_bit?

    system "./autogen.sh"
    system "./configure", *args
    system "make"
    system "make", "check" if build.with? "check"
    system "make", "install"
  end

  test do
    system bin/"wolfssl-config", "--cflags", "--libs", "--prefix"
  end
end
