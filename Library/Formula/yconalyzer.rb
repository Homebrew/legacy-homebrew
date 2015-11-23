class Yconalyzer < Formula
  desc "TCP traffic analyzer"
  homepage "https://sourceforge.net/projects/yconalyzer/"
  url "https://downloads.sourceforge.net/project/yconalyzer/yconalyzer-1.0.4.tar.bz2"
  sha256 "3b2bd33ffa9f6de707c91deeb32d9e9a56c51e232be5002fbed7e7a6373b4d5b"

  bottle do
    cellar :any
    sha1 "1e71b1cbd2446ef4e7776424bf989260023282a7" => :mavericks
    sha1 "da4be93c06dd3fd56425d14a82fb55f848c2f9fc" => :mountain_lion
    sha1 "a9bb41501a0a6e49247702b3e7546cf3af06e25e" => :lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    chmod 0755, "./install-sh"
    system "make", "install"
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
