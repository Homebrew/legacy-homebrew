require 'formula'

class Gnutls < Formula
  homepage 'http://gnutls.org'
  url 'ftp://ftp.gnutls.org/gcrypt/gnutls/v3.2/gnutls-3.2.14.tar.xz'
  mirror 'http://mirrors.dotsrc.org/gcrypt/gnutls/v3.2/gnutls-3.2.14.tar.xz'
  sha1 'a660dfb59bd6f907eeb5c73c540cdddeb51bf8ae'

  bottle do
    cellar :any
    sha1 "a1eb481b7f1491ccb037b3eab9cac96bd5f53208" => :mavericks
    sha1 "d4940ec4744fee5b328b017b01a52b220c521610" => :mountain_lion
    sha1 "a80ad85a49821ca6176a7a3c633f506d30cb8e8f" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'libtasn1'
  depends_on 'gmp'
  depends_on 'nettle'
  depends_on 'guile' => :optional
  depends_on 'p11-kit' => :optional

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-static
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-default-trust-store-file=#{etc}/openssl/cert.pem
    ]

    if build.with? 'guile'
      args << '--enable-guile'
      args << '--with-guile-site-dir=no'
    end

    system "./configure", *args
    system "make install"

    # certtool shadows the OS X certtool utility
    mv bin+'certtool', bin+'gnutls-certtool'
    mv man1+'certtool.1', man1+'gnutls-certtool.1'
  end

  def post_install
    Formula["openssl"].post_install
  end
end
