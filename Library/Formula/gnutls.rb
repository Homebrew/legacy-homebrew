require 'formula'

class Gnutls < Formula
  homepage 'http://gnutls.org'
  url 'ftp://ftp.gnutls.org/gcrypt/gnutls/v3.2/gnutls-3.2.12.1.tar.xz'
  mirror 'http://mirrors.dotsrc.org/gcrypt/gnutls/v3.2/gnutls-3.2.12.1.tar.xz'
  sha1 '5ad26522ec18d6b54a17ff8d1d5b69bf2cd5c7ce'

  bottle do
    cellar :any
    revision 1
    sha1 "3d7a80b824958e69459ef94ecc32f70858ed09cd" => :mavericks
    sha1 "24c1a126da595dd33b99ffe36b868f9cf01f4925" => :mountain_lion
    sha1 "50cc44665107420f2ce5ca9e8ebf7d7ea04b046e" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'libtasn1'
  depends_on 'p11-kit' => :optional
  depends_on 'nettle'
  depends_on 'guile' => :optional

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-static
      --prefix=#{prefix}
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
end
