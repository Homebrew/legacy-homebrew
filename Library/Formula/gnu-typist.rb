class GnuTypist < Formula
  desc "GNU typing tutor"
  homepage "https://www.gnu.org/software/gtypist/"
  url "http://ftpmirror.gnu.org/gtypist/gtypist-2.9.5.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gtypist/gtypist-2.9.5.tar.xz"
  sha256 "c13af40b12479f8219ffa6c66020618c0ce305ad305590fde02d2c20eb9cf977"

  bottle do
    revision 1
    sha256 "38fbd18da939021fe2ba02f505109a68df569d5e89629b97bfb52366be917dae" => :yosemite
    sha256 "e6242d04086f6519b7d1e8150e03c28e83ade7e34162132010d1dc68abb80420" => :mavericks
    sha256 "14030bc96288152a37b885d74c351be91ba18c03d48430ad95b9294d46ff0544" => :mountain_lion
  end

  depends_on "gettext"

  # Use Apple's ncurses instead of ncursesw.
  # TODO: use an IFDEF for apple and submit upstream
  patch :DATA

  def install
    # libiconv is not linked properly without this
    ENV.append "LDFLAGS", "-liconv"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-lispdir=#{share}/emacs/site-lisp/gnu-typist"
    system "make"
    system "make", "install"
  end

  test do
    session = fork do
      exec bin/"gtypist", "-t", "-q", "-l", "DEMO_0", share/"gtypist/demo.typ"
    end
    sleep 2
    Process.kill("TERM", session)
  end
end

__END__
diff --git a/configure b/configure
index 2207b09..915a664 100755
--- a/configure
+++ b/configure
@@ -6301,9 +6301,9 @@ fi
 done


-# check for libncursesw
+# check for libncurses

-ac_fn_c_check_header_mongrel "$LINENO" "ncursesw/ncurses.h" "ac_cv_header_ncursesw_ncurses_h" "$ac_includes_default"
+ac_fn_c_check_header_mongrel "$LINENO" "ncurses.h" "ac_cv_header_ncursesw_ncurses_h" "$ac_includes_default"
 if test "x$ac_cv_header_ncursesw_ncurses_h" = xyes; then :
   HAVE_NCURSESW_H=1
 fi
@@ -6315,7 +6315,7 @@ if ${ac_cv_lib_ncursesw_add_wch+:} false; then :
   $as_echo_n "(cached) " >&6
 else
   ac_check_lib_save_LIBS=$LIBS
-LIBS="-lncursesw  $LIBS"
+LIBS="-lncurses  $LIBS"
 cat confdefs.h - <<_ACEOF >conftest.$ac_ext
 /* end confdefs.h.  */

@@ -6350,7 +6350,7 @@ if test "x$ac_cv_lib_ncursesw_add_wch" = xyes; then :
 fi

 if test -n "$HAVE_NCURSESW_H" -a -n "$HAVE_LIBNCURSESW";  then
-   LIBS="-lncursesw $LIBS"
+   LIBS="-lncurses $LIBS"
 else
    echo -e "Error:  both library and header files for the ncursesw library\n"\
        "are required to build this package.  See INSTALL file for"\
@@ -10553,4 +10553,3 @@ if test -n "$ac_unrecognized_opts" && test "$enable_option_checking" != no; then
   { $as_echo "$as_me:${as_lineno-$LINENO}: WARNING: unrecognized options: $ac_unrecognized_opts" >&5
 $as_echo "$as_me: WARNING: unrecognized options: $ac_unrecognized_opts" >&2;}
 fi
-
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
diff --git a/src/gtypist.c b/src/gtypist.c
index bd5af8d..b634325 100644
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
index ce04d68..f4032e2 100644
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
diff --git a/src/utf8.c b/src/utf8.c
index 8eab3d3..e3194df 100644
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
