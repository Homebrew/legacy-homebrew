require 'formula'

class Gnutls < Formula
  homepage 'http://gnutls.org'
  url 'ftp://ftp.gnutls.org/gcrypt/gnutls/v3.2/gnutls-3.2.15.tar.xz'
  mirror 'http://mirrors.dotsrc.org/gcrypt/gnutls/v3.2/gnutls-3.2.15.tar.xz'
  sha1 '31f289b48b0bf054f5f8c16d3b878615d0ae06fc'

  bottle do
    cellar :any
    sha1 "4a8c788feb8f69e63e3f8f47775f686d6d1639cb" => :mavericks
    sha1 "5e5a0456d7e985398b9e3c50f027f049737cc511" => :mountain_lion
    sha1 "da2aa8a5e307546f774e1d704fb61c2d55fd9ef6" => :lion
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
