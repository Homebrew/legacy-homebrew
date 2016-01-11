class Gts < Formula
  desc "GNU triangulated surface library"
  homepage "http://gts.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/gts/gts/0.7.6/gts-0.7.6.tar.gz"
  sha256 "059c3e13e3e3b796d775ec9f96abdce8f2b3b5144df8514eda0cc12e13e8b81e"

  option :universal

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "netpbm"

  # Fix for newer netpbm.
  # This software hasn't been updated in seven years
  patch :DATA

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make", "install"
  end
end

__END__
diff --git a/examples/happrox.c b/examples/happrox.c
index 88770a8..11f140d 100644
--- a/examples/happrox.c
+++ b/examples/happrox.c
@@ -21,7 +21,7 @@
 #include <stdlib.h>
 #include <locale.h>
 #include <string.h>
-#include <pgm.h>
+#include <netpbm/pgm.h>
 #include "config.h"
 #ifdef HAVE_GETOPT_H
 #  include <getopt.h>
