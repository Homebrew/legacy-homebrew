require 'formula'

class Tn5250 < Formula
  homepage 'http://tn5250.sourceforge.net/'
  url 'http://sourceforge.net/projects/tn5250/files/tn5250/0.17.4/tn5250-0.17.4.tar.gz'
  md5 'd1eb7c5a2e15cd2f43a1c115e2734153'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install" 
    system "make clean"
  end

  def test
    system "false"
  end
  
  def patches
    DATA
  end
end

__END__

--- tn5250-0.17.4/curses/cursesterm.c 2008-11-21 01:12:20.000000000 -0700
+++ cursesterm.c 2012-07-28 11:45:04.000000000 -0600
@@ -22,6 +22,9 @@
#define _TN5250_TERMINAL_PRIVATE_DEFINED
#include "tn5250-private.h"
#include "cursesterm.h"
+#ifdef __APPLE__
+#include <term.h>
+#endif

#ifdef USE_CURSES


--- tn5250-0.17.4/curses/tn5250.c 2008-11-21 01:12:21.000000000 -0700
+++ tn5250.c 2012-07-28 11:37:10.000000000 -0600
@@ -19,6 +19,7 @@
*/

#include "tn5250-private.h"
+#include "cursesterm.h"

Tn5250Session *sess = NULL;
Tn5250Stream *stream = NULL;
