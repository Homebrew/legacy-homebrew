require 'formula'

class Libdvbpsi < Formula
  homepage 'http://www.videolan.org/developers/libdvbpsi.html'
  url 'http://download.videolan.org/pub/libdvbpsi/0.2.2/libdvbpsi-0.2.2.tar.bz2'
  sha1 '562d46ce256a678309f7c39be8cf31eea4bf6757'

  def install
    # Clang doesn't recognize O6.  Just remove it.  Fixes a build error.
    inreplace 'configure', 'CFLAGS="${CFLAGS} -O6"', 'CFLAGS="${CFLAGS}"'
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--enable-release"
    system "make install"
  end
end
