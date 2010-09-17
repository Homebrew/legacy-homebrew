require 'formula'

class TinyFugue <Formula
  url 'http://downloads.sourceforge.net/project/tinyfugue/tinyfugue/5.0%20beta%208/tf-50b8.tar.gz'
  homepage 'http://tinyfugue.sourceforge.net/'
  md5 '3e994e791966d274f63b0e61abf2ef59'

  depends_on 'libnet'

  def patches
    { :p1 => DATA }
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
--- tf-50b8/src/malloc.c        2007-01-13 23:12:39.000000000 +0000
+++ tf-50b8a/src/malloc.c       2010-09-16 11:04:41.000000000 +0100
@@ -11,6 +11,7 @@
 #include "port.h"
 #include "signals.h"
 #include "malloc.h"
+#include <sys/types.h>
 
 caddr_t mmalloc_base = NULL;
 int low_memory_warning = 0;
