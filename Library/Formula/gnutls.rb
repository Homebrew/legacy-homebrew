require 'formula'

class Gnutls <Formula
  url 'http://ftp.gnu.org/pub/gnu/gnutls/gnutls-2.10.2.tar.bz2'
  homepage 'http://www.gnu.org/software/gnutls/gnutls.html'
  sha1 '2704b7b86fc5e3444afcf20feb7bc9ff117d4816'

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
