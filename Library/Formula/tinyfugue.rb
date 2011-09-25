require 'formula'

class Tinyfugue < Formula
  url 'http://downloads.sourceforge.net/project/tinyfugue/tinyfugue/5.0%20beta%208/tf-50b8.tar.gz'
  homepage 'http://tinyfugue.sourceforge.net/'
  sha1 '37bb70bfb7b44d36c28606c6bd45e435502fb4b4'
  version '5.0beta8'

  def patches
    DATA
  end

  def install
    system "./configure"
    system "make install"
  end
end

__END__
diff -ur tf-50b8.orig/src/malloc.c tf-50b8/src/malloc.c
--- tf-50b8.orig/src/malloc.c	2011-09-23 15:25:23.000000000 -0700
+++ tf-50b8/src/malloc.c	2011-09-23 15:25:43.000000000 -0700
@@ -12,7 +12,6 @@
 #include "signals.h"
 #include "malloc.h"

-caddr_t mmalloc_base = NULL;
 int low_memory_warning = 0;
 static char *reserve = NULL;
