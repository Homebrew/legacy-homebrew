require 'formula'

class Xchat < Formula
  homepage 'http://xchat.org'
  url 'http://xchat.org/files/source/2.8/xchat-2.8.8.tar.bz2'
  md5 '6775c44f38e84d06c06c336b32c4a452'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'gtk+'

  # Adjust to newer glib include conventions
  # No upstream activity since 2010
  def patches; DATA; end

  def install
    ENV.append 'LDFLAGS', '-lgmodule-2.0'

    args = %W[--prefix=#{prefix}
              --disable-dependency-tracking
              --enable-openssl
              --disable-python
              --disable-xlib
              --disable-perl
              --disable-plugin]

    # Fails on 32-bit core solo without this
    args << "--disable-mmx" unless MacOS.prefer_64_bit?

    system "./configure", *args
    system "make install"
    rm_rf share+"applications"
    rm_rf share+"pixmaps"
  end
end

__END__
diff --git a/src/common/servlist.c b/src/common/servlist.c
index 1728928..0829c99 100644
--- a/src/common/servlist.c
+++ b/src/common/servlist.c
@@ -24,7 +24,7 @@
 #include <unistd.h>
 
 #include "xchat.h"
-#include <glib/ghash.h>
+#include <glib.h>
 
 #include "cfgfiles.h"
 #include "fe.h"
diff --git a/src/common/text.c b/src/common/text.c
index a219851..6b11174 100644
--- a/src/common/text.c
+++ b/src/common/text.c
@@ -28,7 +28,7 @@
 #include <sys/mman.h>
 
 #include "xchat.h"
-#include <glib/ghash.h>
+#include <glib.h>
 #include "cfgfiles.h"
 #include "chanopt.h"
 #include "plugin.h"
diff --git a/src/common/util.c b/src/common/util.c
index 49517ec..5a0ab6c 100644
--- a/src/common/util.c
+++ b/src/common/util.c
@@ -39,7 +39,7 @@
 #include <errno.h>
 #include "xchat.h"
 #include "xchatc.h"
-#include <glib/gmarkup.h>
+#include <glib.h>
 #include <ctype.h>
 #include "util.h"
 #include "../../config.h"
diff --git a/src/common/xchat.h b/src/common/xchat.h
index 013d6a1..e3f15a8 100644
--- a/src/common/xchat.h
+++ b/src/common/xchat.h
@@ -1,10 +1,6 @@
 #include "../../config.h"
 
-#include <glib/gslist.h>
-#include <glib/glist.h>
-#include <glib/gutils.h>
-#include <glib/giochannel.h>
-#include <glib/gstrfuncs.h>
+#include <glib.h>
 #include <time.h>			/* need time_t */
 
