require 'formula'

class Gnutls < Formula
  homepage 'http://www.gnu.org/software/gnutls/gnutls.html'
  url 'http://ftpmirror.gnu.org/gnutls/gnutls-2.12.14.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/gnutls/gnutls-2.12.14.tar.bz2'
  md5 '555687a7ffefba0bd9de1e71cb61402c'

  depends_on 'pkg-config' => :build
  depends_on 'libgcrypt'
  depends_on 'libtasn1' => :optional

  fails_with_llvm "Undefined symbols when linking", :build => "2326"

  def install
    ENV.universal_binary	# build fat so wine can use it

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
