require 'formula'

class Gnutls <Formula
  url 'http://ftp.gnu.org/pub/gnu/gnutls/gnutls-2.10.1.tar.bz2'
  homepage 'http://www.gnu.org/software/gnutls/gnutls.html'
  sha1 '507ff8ad7c1e042f8ecaa4314f32777e74caf0d3'

  depends_on 'pkg-config' => :build
  depends_on 'libgcrypt'
  depends_on 'libtasn1' => :optional

  def install
    fails_with_llvm "Undefined symbols when linking", :build => "2326"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-guile"
    system "make install"
  end
end
