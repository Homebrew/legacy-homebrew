require "formula"

class SaneBackends < Formula
  homepage "http://www.sane-project.org/"
  url "http://fossies.org/linux/misc/sane-backends-1.0.24.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/s/sane-backends/sane-backends_1.0.24.orig.tar.gz"
  sha1 "c10bcb30a1b092b2c2fe5a86d6a5efc29123ccf9"
  bottle do
    sha1 "c4d014ea40683f69840c63558061e24611fd8703" => :mavericks
    sha1 "8944920bba83da860a454c579c4f38364b1c381d" => :mountain_lion
    sha1 "6bb3c2d4ee5ea86aa96e22ff165fcbaaf5392130" => :lion
  end

  revision 1

  option :universal

  depends_on "jpeg"
  depends_on "libtiff"
  depends_on "libusb-compat"
  depends_on "openssl"

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
    system "make", "install"

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
