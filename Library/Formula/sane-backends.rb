class SaneBackends < Formula
  desc "Backends for scanner access"
  homepage "http://www.sane-project.org/"
  url "https://fossies.org/linux/misc/sane-backends-1.0.25.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/s/sane-backends/sane-backends_1.0.25.orig.tar.gz"
  sha256 "a4d7ba8d62b2dea702ce76be85699940992daf3f44823ddc128812da33dc6e2c"
  bottle do
    revision 1
    sha256 "e8cd147368ca911b15da016a09cb3d0b58843b5169291a75fe2a42fed7c9c887" => :el_capitan
    sha1 "36cbd09583ba8282b149467de09e963d8c2c2a6f" => :yosemite
    sha1 "d12ff8d69dae245177c554c82dbe0acc9c31fd3d" => :mavericks
    sha1 "343224849f6824dba073499bcb0521abd76e9e23" => :mountain_lion
  end

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
https://lists.alioth.debian.org/pipermail/sane-devel/2015-October/033972.html
diff --git a/backend/pieusb_buffer.c b/backend/pieusb_buffer.c
index 53bd867..23fc645 100644
--- a/backend/pieusb_buffer.c
+++ b/backend/pieusb_buffer.c
@@ -100,7 +100,13 @@
 #include <stdio.h>
 #include <fcntl.h>
 #include <sys/mman.h>
+
+#ifdef __APPLE__
+#include <machine/endian.h>
+#elif
 #include <endian.h>
+#endif
+
 
 /* When creating the release backend, make complains about unresolved external
  * le16toh, although it finds the include <endian.h> */
diff --git a/include/sane/sane.h b/include/sane/sane.h
index 5320b4a..736a9cd 100644
--- a/include/sane/sane.h
+++ b/include/sane/sane.h
@@ -20,6 +20,11 @@
 extern "C" {
 #endif
 
+#ifdef __APPLE__
+// Fixes u_long missing error
+#include <sys/types.h>
+#endif
+
 /*
  * SANE types and defines
  */
diff --git a/include/sane/sanei_backend.h b/include/sane/sanei_backend.h
index 1b5afe2..982dedc 100644
--- a/include/sane/sanei_backend.h
+++ b/include/sane/sanei_backend.h
@@ -96,7 +96,9 @@
 #  undef SIG_SETMASK
 # endif
 
+# ifndef __APPLE__
 # define sigset_t               int
+# endif
 # define sigemptyset(set)       do { *(set) = 0; } while (0)
 # define sigfillset(set)        do { *(set) = ~0; } while (0)
 # define sigaddset(set,signal)  do { *(set) |= sigmask (signal); } while (0)
diff --git a/sanei/sanei_ir.c b/sanei/sanei_ir.c
index 42e82ba..0db2c29 100644
--- a/sanei/sanei_ir.c
+++ b/sanei/sanei_ir.c
@@ -29,7 +29,13 @@
 
 #include <stdlib.h>
 #include <string.h>
+#ifdef __APPLE__ //OSX
+#include <sys/types.h>
+#include <limits.h>
+#include <float.h>
+#elif // not OSX
 #include <values.h>
+#endif
 #include <math.h>
 
 #define BACKEND_NAME sanei_ir  /* name of this module for debugging */
