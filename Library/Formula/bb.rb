require 'formula'

class Bb < Formula
  homepage 'http://aa-project.sourceforge.net/bb/'
  url 'http://downloads.sourceforge.net/project/aa-project/bb/1.3rc1/bb-1.3rc1.tar.gz'
  sha1 'e4e87c6079d220d0bd4bdc97428020471a77cf68'

  # Remove obsolete malloc.h includes (or replace with stdlib.h) on OS X,
  # just like the aalib recipe does.
  def patches
    DATA
  end

  depends_on 'aalib'

  def install
    ENV.x11

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "bb"
  end
end

__END__
diff --git a/credits.c b/credits.c
index 77b20d7..872c5e0 100644
--- a/credits.c
+++ b/credits.c
@@ -24,7 +24,6 @@
 #include <math.h>
 #include <limits.h>
 #include <string.h>
-#include <malloc.h>
 #include <stdlib.h>
 #include "bb.h"
 #define STAR 1
diff --git a/credits2.c b/credits2.c
index e28e412..1d78719 100644
--- a/credits2.c
+++ b/credits2.c
@@ -25,7 +25,6 @@
 #include <math.h>
 #include <ctype.h>
 #include <string.h>
-#include <malloc.h>
 #include <stdlib.h>
 #include "bb.h"
 #define STATE (TIME-starttime)
diff --git a/messager.c b/messager.c
index a81677b..ac77d9f 100644
--- a/messager.c
+++ b/messager.c
@@ -22,7 +22,7 @@
  */

 #include <string.h>
-#include <malloc.h>
+#include <stdlib.h>
 #include "bb.h"

 static int cursor_x, cursor_y;
diff --git a/scene5.c b/scene5.c
index d307578..a92eb9e 100644
--- a/scene5.c
+++ b/scene5.c
@@ -22,7 +22,7 @@
  */

 #include <string.h>
-#include <malloc.h>
+#include <stdlib.h>
 #include <math.h>
 #include "bb.h"
 #include "tex.h"
diff --git a/scene8.c b/scene8.c
index 1d84987..d753b96 100644
--- a/scene8.c
+++ b/scene8.c
@@ -22,7 +22,7 @@
  */

 #include <math.h>
-#include <malloc.h>
+#include <stdlib.h>
 #include "bb.h"
 #define STATE1 (TIME-starttime1)
 #define STATE (time-starttime)
diff --git a/textform.c b/textform.c
index 1ded977..ad3b2b8 100644
--- a/textform.c
+++ b/textform.c
@@ -1,6 +1,6 @@
 #include <stdio.h>
 #include <string.h>
-#include <malloc.h>
+#include <stdlib.h>
 #include <aalib.h>
 #include "bb.h"
 #define MAXLINES 10000
diff --git a/timers.c b/timers.c
index ac822f7..f8b3fa5 100644
--- a/timers.c
+++ b/timers.c
@@ -45,11 +45,11 @@
 #include <time.h>
 #endif
    /*HAVE_TIME_H*/
-#include <malloc.h>
+#include <stdlib.h>
 #include <stdio.h>
 #include <unistd.h>
 #ifndef _MAC
-#include <malloc.h>
+#include <stdlib.h>
 #endif
 #ifdef __BEOS__
 #include <OS.h>
diff --git a/uncompfn.c b/uncompfn.c
index 406869a..cd6fba0 100644
--- a/uncompfn.c
+++ b/uncompfn.c
@@ -21,7 +21,7 @@
  * 675 Mass Ave, Cambridge, MA 02139, USA.
  */

-#include <malloc.h>
+#include <stdlib.h>
 #include <aalib.h>
 #include "bb.h"

diff --git a/zoom.c b/zoom.c
index 7450095..4b37b2d 100644
--- a/zoom.c
+++ b/zoom.c
@@ -31,9 +31,6 @@
 #else
 #include <stdlib.h>
 #include <stdio.h>
-#ifndef _MAC
-#include <malloc.h>
-#endif
 #ifdef __DJGPP__
 #include "aconfig.dos"
 #else

