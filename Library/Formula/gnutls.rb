require 'formula'

class Gnutls < Formula
  homepage 'http://gnutls.org'
  url 'ftp://ftp.gnutls.org/gcrypt/gnutls/v3.1/gnutls-3.1.6.tar.xz'
  sha256 '83039b8c243ebaa4c31c96c823c88c8c1576de4a7d0d04e10d93527a535e5e7f'

  depends_on 'xz' => :build
  depends_on 'pkg-config' => :build
  depends_on 'libtasn1'
  depends_on 'p11-kit'
  depends_on 'nettle'

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-static",
                          "--prefix=#{prefix}"
    system "make install"

    # certtool shadows the OS X certtool utility
    mv bin+'certtool', bin+'gnutls-certtool'
    mv man1+'certtool.1', man1+'gnutls-certtool.1'
  end
end
