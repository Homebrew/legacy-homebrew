require 'formula'

class Gnutls < Formula
  homepage 'http://gnutls.org'
  url 'ftp://ftp.gnutls.org/gcrypt/gnutls/v3.1/gnutls-3.1.18.tar.xz'
  mirror 'http://mirrors.dotsrc.org/gcrypt/gnutls/v3.1/gnutls-3.1.18.tar.xz'
  sha1 '360cdb86c1bb6494c27901b5d4c8815b37d5bd4c'

  bottle do
    cellar :any
    sha1 "38e1e08bc111bc626e22ca401668efd6a5a42d06" => :mavericks
    sha1 "bd8a8499a0459ad51b517398535f52fd8c08e411" => :mountain_lion
    sha1 "9780bf542bba844f4603a9f1ddc0a934cafe0a4d" => :lion
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
