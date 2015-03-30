class Pkcrack < Formula
  homepage "https://www.unix-ag.uni-kl.de/~conrad/krypto/pkcrack.html"
  url "https://www.unix-ag.uni-kl.de/~conrad/krypto/pkcrack/pkcrack-1.2.2.tar.gz"
  version "1.2.2"
  sha256 "4d2dc193ffa4342ac2ed3a6311fdf770ae6a0771226b3ef453dca8d03e43895a"

  # Apply to the patch to build on the OSX
  patch :DATA
  def install
    system "make", "-C", "src/"

    # ln -s src/[BINARY] to ${prefix}/bin
    bin.install Dir["src/pkcrack"]
    bin.install Dir["src/findkey"]
    bin.install Dir["src/zipdecrypt"]
    bin.install Dir["src/extract"]
    bin.install Dir["src/makekey"]
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
index 18cdf4a..2858427 100644
--- a/src/exfunc.c
+++ b/src/exfunc.c
@@ -41,7 +41,7 @@
 
 #include <stdio.h>
 #include <string.h>
-#include <malloc.h>
+// #include <malloc.h>
 #include <ctype.h>
 #include "headers.h"
 
diff --git a/src/extract.c b/src/extract.c
index 6cb7800..5d01bb5 100644
--- a/src/extract.c
+++ b/src/extract.c
@@ -68,7 +68,7 @@
 #endif
 
 #include <fcntl.h>
-#include <malloc.h>
+// #include <malloc.h>
 #include <string.h>
 
 #include "headers.h"
@@ -90,7 +90,7 @@ static void usage( char *prg )
     fprintf( stderr, " -s <size>\textract only specified number of bytes\n" );
 }
 
-void main(int argc, char *argv[])
+int main(int argc, char *argv[])
 {
 char	*ret, *outname;
 int	outfile, err=0, i, caseflg=0, size=0;
diff --git a/src/findkey.c b/src/findkey.c
index 0de9dd3..ab2094a 100644
--- a/src/findkey.c
+++ b/src/findkey.c
@@ -56,7 +56,7 @@ static void usage( char *name )
     exit( 1 );
 }
 
-void main( int argc, char **argv )
+int main( int argc, char **argv )
 {
 uword	key0, key1, key2;
 int	pwdLen=0;
diff --git a/src/main.c b/src/main.c
index 8e58072..16cb291 100644
--- a/src/main.c
+++ b/src/main.c
@@ -80,7 +80,7 @@ static char RCSID[]="$Id: main.c,v 1.15 2002/11/12 16:58:02 lucifer Exp $";
 
 #include <sys/stat.h>
 #include <fcntl.h>
-#include <malloc.h>
+// #include <malloc.h>
 #include <stdlib.h>
 #include <string.h>
 
@@ -128,7 +128,7 @@ static void usage( char *myself )
     fprintf( stderr, " -n\tno progress indicator\n" );
 }
 
-void main( int argc, char **argv )
+int main( int argc, char **argv )
 {
 int		crypt, plain, cryptlength, plainlength;
 struct stat	filestat;
diff --git a/src/makekey.c b/src/makekey.c
index 271fab3..bbcae16 100644
--- a/src/makekey.c
+++ b/src/makekey.c
@@ -12,6 +12,7 @@
 
 #include <stdio.h>
 #include <string.h>
+#include <stdlib.h>
 #include "pkcrack.h"
 #include "keystuff.h"
 #include "crc.h"
@@ -24,9 +25,9 @@ static void usage( char *name )
     exit( 1 );
 }
 
-void main( int argc, char **argv )
+int main( int argc, char **argv )
 {
-char *	pwd;  
+char *	pwd;
 int	pwdLen, i;
 
     if( argc != 2 )
@@ -41,5 +42,6 @@ int	pwdLen, i;
 	updateKeys( pwd[i] );
 
     printf( "%08x %08x %08x\n", key0, key1, key2 );
+    return 0;
 }
 
diff --git a/src/readhead.c b/src/readhead.c
index 3ab563c..4d6d810 100644
--- a/src/readhead.c
+++ b/src/readhead.c
@@ -55,7 +55,7 @@
 /* Functions to read signature and headers                                    */
 /******************************************************************************/
 #include <stdio.h>
-#include <malloc.h>
+// #include <malloc.h>
 #include <string.h>
 
 #ifndef _WIN32
diff --git a/src/zdmain.c b/src/zdmain.c
index bfb1f6b..d2d4567 100644
--- a/src/zdmain.c
+++ b/src/zdmain.c
@@ -35,7 +35,7 @@ static char RCSID[]="$Id: zdmain.c,v 1.4 2002/12/28 17:01:42 lucifer Exp $";
 
 extern void zipdecrypt( char*infile, char*outfile, int k0, int k1, int k2 );
 
-void main( int argc, char **argv )
+int main( int argc, char **argv )
 {
 char *c;
 
@@ -53,7 +53,7 @@ char *c;
         break;
     default:
         fprintf( stderr, "Usage: %s {<password> | <key0> <key1> <key2>} <cryptedzipfile> <plainzipfile>\n", argv[0] );
-        return;
+        return 0;
     }
 
     zipdecrypt( argv[argc-2], argv[argc-1], key0, key1, key2 );
diff --git a/src/zipdecrypt.c b/src/zipdecrypt.c
index d26931f..0856b8c 100644
--- a/src/zipdecrypt.c
+++ b/src/zipdecrypt.c
@@ -84,7 +84,7 @@ static char RCSID[]="$Id: zipdecrypt.c,v 1.16 2003/01/05 14:40:37 lucifer Exp $"
 
 #include <sys/stat.h>
 #include <fcntl.h>
-#include <malloc.h>
+// #include <malloc.h>
 #include <string.h>
 #include "pkctypes.h"
 #include "crc.h"
