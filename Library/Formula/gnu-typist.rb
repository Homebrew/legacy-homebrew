require 'formula'

class GnuTypist < Formula
  homepage 'http://www.gnu.org/software/gtypist/'
  url 'http://ftpmirror.gnu.org/gtypist/gtypist-2.9.1.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/gtypist/gtypist-2.9.1.tar.gz'
  sha256 'a5885654aab74027999a67a9bbd7c3b6823479f89a6f1439244bf9c5536fb67d'

  depends_on 'gettext'

  # Use Apple's ncurses instead of ncursesw.
  def patches; DATA; end

  def install
    # libiconv is not linked properly without this
    ENV.append 'LDFLAGS', '-liconv'

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end

__END__
diff --git a/configure b/configure
index b236c98..909733b 100755
--- a/configure
+++ b/configure
@@ -4017,7 +4017,7 @@ if ${ac_cv_lib_ncursesw_add_wch+:} false; then :
   $as_echo_n "(cached) " >&6
 else
   ac_check_lib_save_LIBS=$LIBS
-LIBS="-lncursesw  $LIBS"
+LIBS="-lncurses  $LIBS"
 cat confdefs.h - <<_ACEOF >conftest.$ac_ext
 /* end confdefs.h.  */
 
@@ -4464,7 +4464,7 @@ fi
 done
 
 
-ac_fn_c_check_header_mongrel "$LINENO" "ncursesw/ncurses.h" "ac_cv_header_ncursesw_ncurses_h" "$ac_includes_default"
+ac_fn_c_check_header_mongrel "$LINENO" "ncurses.h" "ac_cv_header_ncursesw_ncurses_h" "$ac_includes_default"
 if test "x$ac_cv_header_ncursesw_ncurses_h" = xyes; then :
   HAVE_NCURSESW_H=1
 fi
@@ -4473,7 +4473,7 @@ fi
 
 # sanity check for libncursesw:
 if test -n "$HAVE_NCURSESW_H" -a -n "$HAVE_LIBNCURSESW";  then
-   LIBS="-lncursesw $LIBS"
+   LIBS="-lncurses $LIBS"
 else
    echo -e "Error:  both library and header files for the ncursesw library\n"\
    	"are required to build this package.  See INSTALL file for"\
diff --git a/src/cursmenu.c b/src/cursmenu.c
index 1c3990e..f0fc21a 100644
--- a/src/cursmenu.c
+++ b/src/cursmenu.c
@@ -24,7 +24,7 @@
 #ifdef HAVE_PDCURSES
 #include <curses.h>
 #else
-#include <ncursesw/ncurses.h>
+#include <ncurses.h>
 #endif
 
 #include "error.h"
diff --git a/src/gtypist.c b/src/gtypist.c
index 747b5b8..7420a12 100644
--- a/src/gtypist.c
+++ b/src/gtypist.c
@@ -31,7 +31,7 @@
 #ifdef HAVE_PDCURSES
 #include <curses.h>
 #else
-#include <ncursesw/ncurses.h>
+#include <ncurses.h>
 #endif
 
 #include <time.h>
diff --git a/src/script.c b/src/script.c
index 34a52b0..06d5686 100644
--- a/src/script.c
+++ b/src/script.c
@@ -24,7 +24,7 @@
 #ifdef HAVE_PDCURSES
 #include <curses.h>
 #else
-#include <ncursesw/ncurses.h>
+#include <ncurses.h>
 #endif
 
 #include "error.h"
diff --git a/src/error.c b/src/error.c
index 2022f2b..4ab6741 100644
--- a/src/error.c
+++ b/src/error.c
@@ -25,7 +25,7 @@
 #ifdef HAVE_PDCURSES
 #include <curses.h>
 #else
-#include <ncursesw/ncurses.h>
+#include <ncurses.h>
 #endif
 
 #include <stdlib.h>
diff --git a/src/utf8.c b/src/utf8.c
index 22476ba..0a44106 100644
--- a/src/utf8.c
+++ b/src/utf8.c
@@ -23,7 +23,7 @@
 #ifdef HAVE_PDCURSES
 #include <curses.h>
 #else
-#include <ncursesw/ncurses.h>
+#include <ncurses.h>
 #endif
 
 #include <stdlib.h>
