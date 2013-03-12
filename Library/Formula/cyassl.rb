require 'formula'

class Cyassl < Formula
  homepage 'http://yassl.com/yaSSL/Products-cyassl.html'
  url 'https://github.com/cyassl/cyassl/archive/v2.5.0.tar.gz'
  sha256 '5fc17c8114582907979a3848291ebb595b0a21db491408968cfa4f91074a3a9d'

  head 'https://github.com/cyassl/cyassl.git'

  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build

  def patches
    # Missing commit from the 2.5.0 tag. Remove with next release.
    "https://github.com/cyassl/cyassl/commit/543d81ba97430844c04c82ea274a99122c9cd1b9.patch"
  end

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
