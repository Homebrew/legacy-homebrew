require 'formula'

class Djvulibre < Formula
  homepage 'http://djvu.sourceforge.net/'

  stable do
    url 'http://ftp.de.debian.org/debian/pool/main/d/djvulibre/djvulibre_3.5.25.4.orig.tar.gz'
    sha1 'c7044201703f30df0f1732c54c6544467412811d'
    # Fixes 10.9 clang/libcxx:
    # http://sourceforge.net/p/djvu/bugs/236/#ce5c/a7ca
    # http://sourceforge.net/p/djvu/djvulibre-git/ci/2c904e/
    patch :DATA
  end

  bottle do
    revision 1
    sha1 "306baf176acba6f71f3381a010fa78ff80e62ba6" => :yosemite
    sha1 "61a53093e18457fb4235cc0afe3717eef851b85e" => :mavericks
  end

  head 'git://git.code.sf.net/p/djvu/djvulibre-git'

  depends_on 'jpeg'
  depends_on 'libtiff'

  def install
    # Don't build X11 GUI apps, Spotlight Importer or QuickLook plugin
    system "./configure", "--prefix=#{prefix}", "--disable-desktopfiles"
    system "make"
    system "make install"
    (share/'doc/djvu').install Dir['doc/*']
  end

  test do
    output = shell_output("#{bin}/djvused -e n #{share}/doc/djvu/lizard2002.djvu")
    assert_equal "2", output.strip
  end
end

__END__
--- a/libdjvu/atomic.h
+++ b/libdjvu/atomic.h
@@ -122,7 +122,7 @@
   static inline int atomicDecrement(int volatile *var) {
     int ov; __asm__ __volatile__ ("lock; xaddl %0, %1"
          : "=r" (ov), "=m" (*var) : "0" (-1), "m" (*var) : "cc" );
-    return ov + 1;
+    return ov - 1;
   }
   static inline int atomicExchange(int volatile *var, int nv) {
     int ov; __asm__ __volatile__ ("xchgl %0, %1"
