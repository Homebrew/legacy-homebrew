require 'formula'

class Gnutls < Formula
  homepage 'http://gnutls.org'
  url 'ftp://ftp.gnutls.org/gcrypt/gnutls/v3.2/gnutls-3.2.13.tar.xz'
  mirror 'http://mirrors.dotsrc.org/gcrypt/gnutls/v3.2/gnutls-3.2.13.tar.xz'
  sha1 'c4a95902bb67df46e9b2c08d4c10523db94e2736'

  bottle do
    cellar :any
    sha1 "d47f9d4adc2ed860c351edef7729e206b493012d" => :mavericks
    sha1 "67dc1e554a4af1b004d1fdb3ae0dad7261cfbbe0" => :mountain_lion
    sha1 "75ec84c8ae2f519327e2230f18e7508c33da9add" => :lion
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
