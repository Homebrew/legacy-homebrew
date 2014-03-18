require 'formula'

class Aalib < Formula
  homepage 'http://aa-project.sourceforge.net/aalib/'
  url 'https://downloads.sourceforge.net/aa-project/aalib-1.4rc5.tar.gz'
  sha1 'a23269e950a249d2ef93625837cace45ddbce03b'

  # Fix malloc/stdlib issue on OS X
  # Fix underquoted definition of AM_PATH_AALIB in aalib.m4
  patch :DATA

  def install
    ENV.ncurses_define
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}",
                          "--enable-shared=yes",
                          "--enable-static=yes",
                          "--without-x"
    system "make install"
  end
end

__END__
diff --git a/src/aaedit.c b/src/aaedit.c
index 09534d2..2ea52f9 100644
--- a/src/aaedit.c
+++ b/src/aaedit.c
@@ -1,6 +1,6 @@
 #include <string.h>
 #include <ctype.h>
-#include <malloc.h>
+#include <stdlib.h>
 #include "aalib.h"
 #include "aaint.h"
 static void aa_editdisplay(struct aa_edit *e)
 
diff --git a/src/aakbdreg.c b/src/aakbdreg.c
index def65fe..f4f8efb 100644
--- a/src/aakbdreg.c
+++ b/src/aakbdreg.c
@@ -1,4 +1,4 @@
-#include <malloc.h>
+#include <stdlib.h>
 #include "config.h"
 #include "aalib.h"
 #include "aaint.h"
diff --git a/src/aalib.c b/src/aalib.c
index 11fecc8..e3063b4 100644
--- a/src/aalib.c
+++ b/src/aalib.c
@@ -1,6 +1,6 @@
 #include <stdio.h>
 #include <string.h>
-#include <malloc.h>
+#include <stdlib.h>
 #include "aalib.h"
 #include "aaint.h"
 
diff --git a/src/aamoureg.c b/src/aamoureg.c
index 0380828..bb55fe3 100644
--- a/src/aamoureg.c
+++ b/src/aamoureg.c
@@ -1,4 +1,4 @@
-#include <malloc.h>
+#include <stdlib.h>
 #include "config.h"
 #include "aalib.h"
 #include "aaint.h"
diff --git a/src/aarec.c b/src/aarec.c
index 70f4ebc..ee43e8a 100644
--- a/src/aarec.c
+++ b/src/aarec.c
@@ -1,5 +1,5 @@
 #include <string.h>
-#include <malloc.h>
+#include <stdlib.h>
 #include "aalib.h"
 #include "aaint.h"
 aa_linkedlist *aa_kbdrecommended = NULL, *aa_mouserecommended = NULL,
diff --git a/src/aaregist.c b/src/aaregist.c
index 54abec0..765155e 100644
--- a/src/aaregist.c
+++ b/src/aaregist.c
@@ -1,4 +1,4 @@
-#include <malloc.h>
+#include <stdlib.h>
 #include "config.h"
 #include "aalib.h"
 #include "aaint.h"
diff --git a/src/aax.c b/src/aax.c
index adcbd82..36e3294 100644
--- a/src/aax.c
+++ b/src/aax.c
@@ -1,4 +1,3 @@
-#include <malloc.h>
 #include <stdlib.h>
 #include <string.h>
 #include <stdio.h>
diff --git a/src/aaxkbd.c b/src/aaxkbd.c
index 30d5903..da2248d 100644
--- a/src/aaxkbd.c
+++ b/src/aaxkbd.c
@@ -1,4 +1,3 @@
-#include <malloc.h>
 #include <stdlib.h>
 #include <string.h>
 #include <stdio.h>
diff --git a/src/aaxmouse.c b/src/aaxmouse.c
index 9935b03..7e725ad 100644
--- a/src/aaxmouse.c
+++ b/src/aaxmouse.c
@@ -1,4 +1,3 @@
-#include <malloc.h>
 #include <stdlib.h>
 #include <string.h>
 #include <stdio.h>
diff --git a/aalib.m4 b/aalib.m4
index c40b8db..991fbda 100644
--- a/aalib.m4
+++ b/aalib.m4
@@ -9,7 +9,7 @@
 dnl AM_PATH_AALIB([MINIMUM-VERSION, [ACTION-IF-FOUND [, ACTION-IF-NOT-FOUND]]])
 dnl Test for AALIB, and define AALIB_CFLAGS and AALIB_LIBS
 dnl
-AC_DEFUN(AM_PATH_AALIB,
+AC_DEFUN([AM_PATH_AALIB],
 [dnl 
 dnl Get the cflags and libraries from the aalib-config script
 dnl
