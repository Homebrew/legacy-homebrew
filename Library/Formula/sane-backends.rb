require 'formula'

class SaneBackends < Formula
  url 'ftp://ftp2.sane-project.org/pub/sane/sane-backends-1.0.22/sane-backends-1.0.22.tar.gz'
  homepage 'http://www.sane-project.org/'
  md5 'fadf56a60f4776bfb24491f66b617cf5'

  depends_on 'jpeg'
  depends_on 'libtiff'
  depends_on 'libusb-compat'

  skip_clean "var/lock/sane"

  def patches
    # Fixes u_long missing error
    DATA
  end

  def install
    ENV.j1 # Makefile does not seem to be parallel-safe
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-gphoto2",
                          "--enable-local-backends",
                          "--enable-libusb",
                          "--disable-latex"
    system "make"
    system "make install"

    # Some drivers require a lockfile
    (var+"lock/sane").mkpath
  end
end

__END__
diff --git a/include/sane/sane.h.orig b/include/sane/sane.h
index 5320b4a..6cb7090 100644
--- a/include/sane/sane.h.orig
+++ b/include/sane/sane.h
@@ -20,6 +20,9 @@
 extern "C" {
 #endif
 
+// Fixes u_long missing error
+#include <sys/types.h>
+
 /*
  * SANE types and defines
  */
