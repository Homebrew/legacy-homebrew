require 'formula'

class Gnutls < Formula
  homepage 'http://gnutls.org'
  url 'ftp://ftp.gnutls.org/gcrypt/gnutls/v3.2/gnutls-3.2.8.tar.xz'
  mirror 'http://mirrors.dotsrc.org/gcrypt/gnutls/v3.2/gnutls-3.2.8.tar.xz'
  sha1 '8b6e55a6e94983600563e92d3ebd0caba5c4aeb7'

  depends_on 'xz' => :build
  depends_on 'pkg-config' => :build
  depends_on 'libtasn1'
  depends_on 'p11-kit'
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
