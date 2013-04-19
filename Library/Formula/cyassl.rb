require 'formula'

class Cyassl < Formula
  homepage 'http://yassl.com/yaSSL/Products-cyassl.html'
  url 'https://github.com/cyassl/cyassl/archive/v2.6.0.tar.gz'
  sha256 '61735c47e14065162986579d866ea7bd98af30e0e6bb5ac34367122ba1959b62'

  head 'https://github.com/cyassl/cyassl.git'

  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build

  fails_with :clang

  def install
    args = %W[--infodir=#{info}
              --mandir=#{man}
              --prefix=#{prefix}
              --enable-aesccm
              --enable-aesgcm
              --enable-camellia
              --enable-certgen
              --enable-crl
              --enable-crl-monitor
              --enable-dtls
              --enable-fortress
              --enable-hc128
              --enable-keygen
              --enable-ocsp
              --enable-opensslExtra
              --enable-psk
              --enable-rabbit
              --enable-ripemd
              --enable-sha512
              --enable-sniffer
              --disable-ecc
              --disable-noFilesystem
              --disable-noInline
              --disable-ntru
              --disable-webServer
              --with-libz
    ]

    if MacOS.prefer_64_bit?
      args << '--enable-fastmath' << '--enable-fasthugemath' << '--enable-bump'
    else
      args << '--disable-fastmath' << '--disable-fasthugemath' << '--disable-bump'
    end

    # Extra flag is stated as a needed for the Mac platform.
    # http://yassl.com/yaSSL/Docs-cyassl-manual-2-building-cyassl.html
    # Also, only applies if fastmath is enabled.
    ENV.append_to_cflags '-mdynamic-no-pic' if MacOS.prefer_64_bit?

    # No public release available, Git tag is therefore used.
    system "autoreconf --verbose --install --force"
    system "./configure", *args

    system "make"
    system "make install"
  end
end
