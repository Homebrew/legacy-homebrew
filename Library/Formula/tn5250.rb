class Tn5250 < Formula
  desc "5250 terminal and printer emulator"
  homepage "http://tn5250.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/tn5250/tn5250/0.17.4/tn5250-0.17.4.tar.gz"
  sha256 "354237d400dc46af887cb3ffa4ed1f2c371f5b8bee8be046a683a4ac9db4f9c5"
  revision 1

  bottle do
    sha256 "3d799f665866c2fa21ca2712682178ba64cdb2b5bf0ad77705de6ec869c529c7" => :el_capitan
    sha256 "e7c01e8c5c3e732c9f36e7480f788a2ca7387ada7d74daaccb06d48b7fafdac4" => :yosemite
    sha256 "992b0e0f6fdedf1030a0326936fc7533a013639385d39a590d6b68a8728844dd" => :mavericks
  end

  depends_on "openssl"

  # Fix segfault; reported here:
  # http://archive.midrange.com/linux5250/201207/msg00000.html
  patch :DATA

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end

__END__
diff --git a/curses/cursesterm.c b/curses/cursesterm.c
index bf20f05..b9c394c 100644
--- a/curses/cursesterm.c
+++ b/curses/cursesterm.c
@@ -22,6 +22,9 @@
 #define _TN5250_TERMINAL_PRIVATE_DEFINED
 #include "tn5250-private.h"
 #include "cursesterm.h"
+#ifdef __APPLE__
+#include <term.h>
+#endif
 
 #ifdef USE_CURSES
 
diff --git a/curses/tn5250.c b/curses/tn5250.c
index 30a1627..67392b1 100644
--- a/curses/tn5250.c
+++ b/curses/tn5250.c
@@ -19,6 +19,7 @@
  */
 
 #include "tn5250-private.h"
+#include "cursesterm.h"
 
 Tn5250Session *sess = NULL;
 Tn5250Stream *stream = NULL;
