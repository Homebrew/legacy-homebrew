require 'formula'

class TinyFugue < Formula
  url 'http://downloads.sourceforge.net/project/tinyfugue/tinyfugue/5.0%20beta%208/tf-50b8.tar.gz'
  homepage 'http://tinyfugue.sourceforge.net/'
  md5 '3e994e791966d274f63b0e61abf2ef59'
  version '5.0b8'

  depends_on 'libnet'

  def patches
    DATA
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--enable-getaddrinfo", "--enable-termcap=ncurses",
                          "--prefix=#{prefix}"
    system "make install"
  end
end


__END__
diff --git a/src/malloc.c b/src/malloc.c
index 03ca393..7282f02 100644
--- a/src/malloc.c
+++ b/src/malloc.c
@@ -7,6 +7,7 @@
  ************************************************************************/
 static const char RCSid[] = "$Id: malloc.c,v 35004.22 2007/01/13 23:12:39 kkeys Exp $";
 
+#include "sys/types.h"
 #include "tfconfig.h"
 #include "port.h"
 #include "signals.h"
