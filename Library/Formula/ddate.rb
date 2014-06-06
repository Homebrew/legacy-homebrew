require 'formula'

class Ddate < Formula
  homepage 'http://www.discordia.ch/Programs/'
  url 'www.discordia.ch/Programs/ddate.c'
  version '0.1.0'
  sha1 '41eafa66d577082b95e40a8f40ac054aa8ea45dc'

  patch :DATA
  patch :p0, :DATA

  def install
    system ENV.cc, "ddate.c", "-o", "ddate"
    bin.install 'ddate'
  end
end

__END__
diff --git a/ddate.c b/ddate.c
index 9f0d0d0..f471466 100644
--- a/ddate.c
+++ b/ddate.c
@@ -13,6 +13,7 @@
 #include <time.h>
 #include <string.h>
 #include <stdio.h>
+#include <stdlib.h>
 
 struct disc_time
 {int season; /* 0-4 */
@@ -39,7 +40,7 @@ main (int argc,char **argv)
       hastur=makeday(moe,larry,curly);
     }
   else if (argc!=1)
-    { fprintf(stderr,"Syntax: DiscDate [month day year]");
+    { fprintf(stderr,"Syntax: ddate [month day year]\n");
       exit(1);
     }
   else

