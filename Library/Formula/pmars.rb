require 'formula'

class Pmars < Formula
  url 'http://sourceforge.net/projects/corewar/files/pMARS/0.9.2/pmars-0.9.2.tar.gz'
  version '0.9.2'
  homepage 'hhttp://corewar.co.uk/pmars/'
  md5 'a73943a34e9de8f0d3028fc4566cd558'

  def patches
    DATA
  end

  def install
    cd 'src' do
      system 'make'
      bin.install 'pmars'
    end
    share.install 'warriors' => 'pmars-warriors'
    man6.install gzip('doc/pmars.6')
  end

  def caveats; <<-EOS.undent
    Example:
      pmars -v 994 -P /usr/local/share/pmars-warriors/aeka.red /usr/local/share/pmars-warriors/rave.red
      pmars -v 994 /usr/local/share/pmars-warriors/aeka.red
      pmars -v 0 /usr/local/share/pmars-warriors/aeka.red
    EOS
  end
  
  def test
    system "#{bin}/pmars",'-v','0',"#{share}/pmars-warriors/aeka.red"
  end
end

__END__
---
 src/Makefile  |    4 ++--
 src/curdisp.c |   11 ++++++-----
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/src/Makefile b/src/Makefile
index 99c00bb..21b5e9f 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -16,11 +16,11 @@ CC = gcc			# req. for linux
 # (6)   -DXWINGRAPHX    1                   X-Windows graphics (UNIX)
 # (7)   -DPERMUTATE                         enables -P switch
 
-CFLAGS = -O -DEXT94 -DXWINGRAPHX -DPERMUTATE
+CFLAGS = -O -DEXT94 -DCURSESGRAPHX -DUNIX -DPERMUTATE -fno-builtin
 LFLAGS = -x
+LIB = -lcurses
 # LIB = -lcurses -ltermlib		# enable this one for curses display
 # LIB = -lvgagl -lvga			# enable this one for Linux/SVGA
-LIB = -L/usr/X11R6/lib -lX11		# enable this one for X11
 
 .SUFFIXES: .o .c .c~ .man .doc .6
 MAINFILE = pmars
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
-- 
1.7.6.1
