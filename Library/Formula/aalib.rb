class Aalib < Formula
  desc "Portable ASCII art graphics library"
  homepage "http://aa-project.sourceforge.net/aalib/"
  url "https://downloads.sourceforge.net/aa-project/aalib-1.4rc5.tar.gz"
  sha256 "fbddda9230cf6ee2a4f5706b4b11e2190ae45f5eda1f0409dc4f99b35e0a70ee"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "06bd52bb36bc45e839cc6581baa11580d8ab786f83fd878e725d1b0923497c7b" => :el_capitan
    sha256 "f018850bc3f7cb622b5fd19a1b9910f5be3218b70cbf36e158f0f241ddff05ec" => :yosemite
    sha256 "45922d8c9e423b8249bfee4263d9b7c848eec19e72f553ce9271eb60795ae6ff" => :mavericks
    sha256 "b2fd6584ff2ad3afc0050e0663ad680f84c79d59958afb043681bac77e9fd2fc" => :mountain_lion
  end

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
    system "make", "install"
  end

  test do
    system "script", "-q", "/dev/null", bin/"aainfo"
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
