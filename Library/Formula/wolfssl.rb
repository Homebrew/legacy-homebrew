class Wolfssl < Formula
  desc "Embedded SSL Library written in C"
  homepage "https://www.wolfssl.com/wolfSSL/Home.html"
  url "https://github.com/wolfSSL/wolfssl/archive/v3.7.0.tar.gz"
  sha256 "66bde9fd9ae0eb557d2603117017cb04c12cbecb34296bb7949d509577e42ae4"
  head "https://github.com/wolfSSL/wolfssl.git"

  bottle do
    cellar :any
    sha256 "6ef0f5121a7486d05fc097e5d12abb0930a5a5c4d0fa470a4584a93718eb40b4" => :yosemite
    sha256 "ec404ac09e2a16219c53bbfe235363cf2a940ffcff53f01bb811420ac5bece22" => :mavericks
    sha256 "3a77e9919894765aeab5b9c08bbea00bf590bf0e85afbcbfd43d6207fc29d451" => :mountain_lion
  end

  option "without-check", "Skip compile-time tests."

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
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
      --disable-md5
      --disable-sniffer
      --disable-webserver
      --enable-aesccm
      --enable-aesgcm
      --enable-alpn
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
      --enable-ed25519
      --enable-filesystem
      --enable-hc128
      --enable-hkdf
      --enable-inline
      --enable-ipv6
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
    # https://wolfssl.com/wolfSSL/Docs-wolfssl-manual-2-building-wolfssl.html
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
