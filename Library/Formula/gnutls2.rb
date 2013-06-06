require 'formula'

# Gnutls3 changes the API, but also changes the license, which makes it
# unlikely for many projects to update.
class Gnutls2 < Formula
  homepage 'http://www.gnu.org/software/gnutls/gnutls.html'
  url 'http://ftpmirror.gnu.org/gnutls/gnutls-2.12.21.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/gnutls/gnutls-2.12.21.tar.bz2'
  sha256 '2bd020665951f38a230d6b6d98630f8c47ca6977d7d86977d356ccf17756fbf3'

  keg_only "GnuTLS 2 is provided for software that doesn't compile against newer versions."

  depends_on 'pkg-config' => :build
  depends_on 'libgcrypt'
  depends_on 'libtasn1'
  depends_on 'p11-kit'

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  def install
    ENV.append 'LDFLAGS', '-ltasn1' # find external libtasn1

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-guile",
                          "--disable-static",
                          "--prefix=#{prefix}",
                          "--with-libgcrypt"
    system "make install"

    # certtool shadows the OS X certtool utility
    mv bin/'certtool', bin/'gnutls-certtool'
    mv man1/'certtool.1', man1/'gnutls-certtool.1'
  end
end
