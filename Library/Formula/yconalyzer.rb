require 'formula'

class Yconalyzer < Formula
  homepage 'http://sourceforge.net/projects/yconalyzer/'
  url 'https://downloads.sourceforge.net/project/yconalyzer/yconalyzer-1.0.4.tar.bz2'
  sha1 'a8fcbf1ce2a0e8612448cc997e904cc572473bcc'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "chmod +x ./install-sh"
    system "make install"
  end

  # Fix build issues issue on OS X 10.9/clang
  # Patch reported to upstream - https://sourceforge.net/p/yconalyzer/bugs/3/
  patch :p0, :DATA

end
__END__
--- yconalyzer.cc.orig	2014-01-12 14:15:17.000000000 +0800
+++ yconalyzer.cc	2014-01-12 14:17:49.000000000 +0800
@@ -76,19 +76,11 @@

 #include <string>

-#if __GNUC__ > 2
 #include <map>
-using namespace _GLIBCXX_STD;
+using namespace std;
 // Linux gcc-3 is not too happy with the format strings we use in BSD.
 #define KEY_FMT_STRING "%#8x%#4x"

-#else	/* We are using gnu-c <= 2 */
-
-#include <hash_map.h>
-#define KEY_FMT_STRING "%8ux%4hx"
-
-#endif
-
 static int debug = 0;
 static u_short port = 0;
 static int nbuckets;
