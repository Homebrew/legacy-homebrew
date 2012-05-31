require 'formula'

class Gnutls < Formula
  homepage 'http://www.gnu.org/software/gnutls/gnutls.html'
  url 'http://ftpmirror.gnu.org/gnutls/gnutls-2.12.18.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/gnutls/gnutls-2.12.18.tar.bz2'
  md5 'e9215d00d2930e09bc8f23f02b54f2d1'

  depends_on 'pkg-config' => :build
  depends_on 'libgcrypt'
  depends_on 'libtasn1' => :optional

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  def install
    ENV.universal_binary # build fat so wine can use it
    ENV.append 'LDFLAGS', '-ltasn1' # find external libtasn1

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-guile",
                          "--disable-static",
                          "--prefix=#{prefix}",
                          "--with-libgcrypt",
                          "--without-p11-kit"
    system "make install"

    # certtool shadows the OS X certtool utility
    mv bin+'certtool', bin+'gnutls-certtool'
    mv man1+'certtool.1', man1+'gnutls-certtool.1'
  end
end
