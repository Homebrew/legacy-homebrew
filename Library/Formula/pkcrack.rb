class Pkcrack < Formula
  homepage "https://www.unix-ag.uni-kl.de/~conrad/krypto/pkcrack.html"
  url "https://www.unix-ag.uni-kl.de/~conrad/krypto/pkcrack/pkcrack-1.2.2.tar.gz"
  sha256 "4d2dc193ffa4342ac2ed3a6311fdf770ae6a0771226b3ef453dca8d03e43895a"

  # Apply to the patch to build on the OSX
  # I rewrite "#include<malloc.h>" to "#include<stdlib.h>" because OSX doesn't have 'malloc.h'
  patch :DATA
  def install
    system "make", "-C", "src/"
    bin.install Dir["src/*"].select { |f| File.executable? f }
  end

  test do
    `pkcrack > /dev/null 2>&1`
    assert_equal 1, $?.exitstatus
  end
end

__END__
diff --git a/src/Makefile b/src/Makefile
index af87e95..1226a2c 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -1,5 +1,5 @@
 CC=gcc
-CFLAGS=-O6 -Wall
+CFLAGS=-O2 -Wall
 #CFLAGS=-g
 
 RM=rm -f
diff --git a/src/exfunc.c b/src/exfunc.c
index 18cdf4a..e33e29c 100644
--- a/src/exfunc.c
+++ b/src/exfunc.c
@@ -41,7 +41,8 @@
 
 #include <stdio.h>
 #include <string.h>
-#include <malloc.h>
+//#include <malloc.h>
+#include <stdlib.h>
 #include <ctype.h>
 #include "headers.h"
 
diff --git a/src/extract.c b/src/extract.c
index 6cb7800..cd4535d 100644
--- a/src/extract.c
+++ b/src/extract.c
@@ -68,7 +68,8 @@
 #endif
 
 #include <fcntl.h>
-#include <malloc.h>
+//#include <malloc.h>
+#include <stdlib.h>
 #include <string.h>
 
 #include "headers.h"
diff --git a/src/main.c b/src/main.c
index 8e58072..4b1474b 100644
--- a/src/main.c
+++ b/src/main.c
@@ -80,7 +80,7 @@ static char RCSID[]="$Id: main.c,v 1.15 2002/11/12 16:58:02 lucifer Exp $";
 
 #include <sys/stat.h>
 #include <fcntl.h>
-#include <malloc.h>
+//#include <malloc.h>
 #include <stdlib.h>
 #include <string.h>
 
diff --git a/src/readhead.c b/src/readhead.c
index 3ab563c..9a6cf5d 100644
--- a/src/readhead.c
+++ b/src/readhead.c
@@ -55,7 +55,8 @@
 /* Functions to read signature and headers                                    */
 /******************************************************************************/
 #include <stdio.h>
-#include <malloc.h>
+//#include <malloc.h>
+#include <stdlib.h>
 #include <string.h>
 
 #ifndef _WIN32
diff --git a/src/zipdecrypt.c b/src/zipdecrypt.c
index d26931f..7c6cbbc 100644
--- a/src/zipdecrypt.c
+++ b/src/zipdecrypt.c
@@ -84,7 +84,7 @@ static char RCSID[]="$Id: zipdecrypt.c,v 1.16 2003/01/05 14:40:37 lucifer Exp $"
 
 #include <sys/stat.h>
 #include <fcntl.h>
-#include <malloc.h>
+//#include <malloc.h>
 #include <string.h>
 #include "pkctypes.h"
 #include "crc.h"
