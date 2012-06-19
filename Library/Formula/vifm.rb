require 'formula'

class Vifm < Formula
  homepage 'http://vifm.sourceforge.net/index.html'
  url 'http://sourceforge.net/projects/vifm/files/vifm-0.7.3.tar.bz2'
  sha1 '2198f387d607da074fd3653b3662587a5a706785'

  # OS X provides "ncurses" not "ncursesw"
  def patches
    DATA
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
diff --git a/configure b/configure
index 16a10f5..0d77a28 100755
--- a/configure
+++ b/configure
@@ -13307,13 +13307,13 @@ if test "${with_curses+set}" = set; then :
 fi
 
 
-{ $as_echo "$as_me:${as_lineno-$LINENO}: checking for initscr in -lncursesw" >&5
-$as_echo_n "checking for initscr in -lncursesw... " >&6; }
+{ $as_echo "$as_me:${as_lineno-$LINENO}: checking for initscr in -lncurses" >&5
+$as_echo_n "checking for initscr in -lncurses... " >&6; }
 if ${ac_cv_lib_ncursesw_initscr+:} false; then :
   $as_echo_n "(cached) " >&6
 else
   ac_check_lib_save_LIBS=$LIBS
-LIBS="-lncursesw  $LIBS"
+LIBS="-lncurses  $LIBS"
 cat confdefs.h - <<_ACEOF >conftest.$ac_ext
 /* end confdefs.h.  */
 
@@ -13344,9 +13344,9 @@ fi
 { $as_echo "$as_me:${as_lineno-$LINENO}: result: $ac_cv_lib_ncursesw_initscr" >&5
 $as_echo "$ac_cv_lib_ncursesw_initscr" >&6; }
 if test "x$ac_cv_lib_ncursesw_initscr" = xyes; then :
-  LIBS="$LIBS -lncursesw"
-	if test x$vifm_cv_curses = x/usr -a -d /usr/include/ncursesw; then
-		CPPFLAGS="$CPPFLAGS -I/usr/include/ncursesw"
+  LIBS="$LIBS -lncurses"
+	if test x$vifm_cv_curses = x/usr -a -d /usr/include/ncurses; then
+		CPPFLAGS="$CPPFLAGS -I/usr/include/ncurses"
 	fi
 	for ac_header in ncurses.h
 do :
