require 'formula'

class SaneBackends < Formula
  homepage 'http://www.sane-project.org/'
  url 'http://fossies.org/linux/misc/sane-backends-1.0.24.tar.gz'
  sha1 'c10bcb30a1b092b2c2fe5a86d6a5efc29123ccf9'

  option :universal

  depends_on 'jpeg'
  depends_on 'libtiff'
  depends_on 'libusb-compat'

  # Fixes u_long missing error. Reported upstream:
  # https://github.com/fab1an/homebrew/commit/2a716f1a2b07705aa891e2c7fbb5148506aa5a01
  # When updating this formula, check on the usptream status of this patch.
  patch :DATA

  def install
    ENV.universal_binary if build.universal?
    ENV.j1 # Makefile does not seem to be parallel-safe
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
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
