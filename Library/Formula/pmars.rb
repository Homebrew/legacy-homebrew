class Pmars < Formula
  homepage "http://www.koth.org/pmars/"
  url "https://downloads.sourceforge.net/project/corewar/pMARS/0.9.2/pmars-0.9.2.tar.gz"
  sha1 "b49162a4f63ed6c4e94e28b762c41ff73057b99f"

  # Fixes compilation when using ncurses
  patch :DATA

  def install
    system "make", "-C", "src",
           "LIB=-lcurses",
           "CFLAGS=-O -DEXT94 -DCURSESGRAPHX -DUNIX -DPERMUTATE -fno-builtin"
    bin.install "src/pmars"
    man6.install "doc/pmars.6"
    share.install "warriors" => "pmars-warriors"
  end

  test do
    system "#{bin}/pmars", "-v", "0", "#{share}/pmars-warriors/aeka.red"
  end
end

__END__
diff --git a/src/curdisp.c b/src/curdisp.c
index 168786b..828f694 100644
--- a/src/curdisp.c
+++ b/src/curdisp.c
@@ -428,7 +428,8 @@ agets5(str, maxchar, attr)
           str--;
           maxchar++;
           leaveok(curwin, TRUE);
-          if (ox = curwin->_curx) {
+          getyx(curwin, oy, ox);
+          if (ox) {
 #if 0
 #ifdef ATTRIBUTE
             mvwaddch(curwin, curwin->_cury, --ox, ' ' | attr);
@@ -436,10 +437,10 @@ agets5(str, maxchar, attr)
             mvwaddch(curwin, curwin->_cury, --ox, ' ');
 #endif
 #endif                                /* 0 */
-            mvwaddch(curwin, curwin->_cury, --ox, ' ');
-            wmove(curwin, curwin->_cury, ox);
+            mvwaddch(curwin, oy, --ox, ' ');
+            wmove(curwin, oy, ox);
           } else {
-            oy = curwin->_cury - 1;
+            oy = oy - 1;
 #if 0
 #ifdef ATTRIBUTE
             mvwaddch(curwin, oy, COLS - 1, ' ' | attr);
@@ -475,7 +476,7 @@ agets5(str, maxchar, attr)
             mvwaddch(curwin, curwin->_cury, ox, ' ');
 #endif
 #endif                                /* 0 */
-          mvwaddch(curwin, curwin->_cury, ox, ' ');
+          mvwaddch(curwin, oy, ox, ' ');
           else
 #if 0
 #ifdef ATTRIBUTE

