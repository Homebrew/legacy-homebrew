require 'formula'

class Gts < Formula
  homepage 'http://gts.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/gts/gts/0.7.6/gts-0.7.6.tar.gz'
  sha1 '000720bebecf0b153eb28260bd30fbd979dcc040'

  option :universal

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'netpbm'

  conflicts_with 'pcb', :because => 'both install `include/gts.h`'

  # Fix for newer netpbm.
  # This software hasn't been updated in seven years
  patch :DATA

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make install"
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
