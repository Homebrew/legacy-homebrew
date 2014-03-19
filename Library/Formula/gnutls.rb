require 'formula'

class Gnutls < Formula
  homepage 'http://gnutls.org'
  url 'ftp://ftp.gnutls.org/gcrypt/gnutls/v3.2/gnutls-3.2.12.1.tar.xz'
  mirror 'http://mirrors.dotsrc.org/gcrypt/gnutls/v3.2/gnutls-3.2.12.1.tar.xz'
  sha1 '5ad26522ec18d6b54a17ff8d1d5b69bf2cd5c7ce'

  bottle do
    cellar :any
    sha1 "63c97291213e9f02872aac775fa8608f9fde8f9d" => :mavericks
    sha1 "af89106ed194090f9aabe0a6705f22b63ca24f32" => :mountain_lion
    sha1 "76cf541a1736da00417d499b3223b80c0677ed18" => :lion
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
