require 'formula'

class Aview <Formula
  url 'http://prdownloads.sourceforge.net/aa-project/aview-1.3.0rc1.tar.gz'
  homepage 'http://aa-project.sourceforge.net/aview/'
  md5 '093f298e7787591e229b59d039c72f4d'

  depends_on 'aalib'

  def patches
    DATA
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end

__END__
diff --git a/image.c b/image.c
index 232b838..9780e61 100644
--- a/image.c
+++ b/image.c
@@ -1,6 +1,6 @@
 #include <stdio.h>
 #include <unistd.h>
-#include <malloc.h>
+#include <stdlib.h>
 #include "config.h"
 
 int imgwidth, imgheight;
diff --git a/ui.c b/ui.c
index d316f7a..134a4ca 100644
--- a/ui.c
+++ b/ui.c
@@ -1,6 +1,6 @@
 #include <stdio.h>
 #include <ctype.h>
-#include <malloc.h>
+#include <stdlib.h>
 #include <string.h>
 #include <aalib.h>
 #include "shrink.h"

