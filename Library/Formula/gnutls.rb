require 'formula'

class Gnutls < Formula
  homepage 'http://gnutls.org'
  url 'ftp://ftp.gnutls.org/gcrypt/gnutls/v3.1/gnutls-3.1.22.tar.xz'
  mirror 'http://mirrors.dotsrc.org/gcrypt/gnutls/v3.1/gnutls-3.1.22.tar.xz'
  sha1 'bcad9df1aa4a5b8dcb81df940d12e1ed53a4f850'

  bottle do
    cellar :any
    sha1 "21a9dcc6e3dc3a7a0262e1236dd20dd9cfd7e1fa" => :mavericks
    sha1 "7ad8b16281739e59da9455b79def333342f8565d" => :mountain_lion
    sha1 "ec3fc2d559296348046e27f1356beb0d65be9ff0" => :lion
  end

  depends_on 'xz' => :build
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
