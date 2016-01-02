class Yconalyzer < Formula
  desc "TCP traffic analyzer"
  homepage "https://sourceforge.net/projects/yconalyzer/"
  url "https://downloads.sourceforge.net/project/yconalyzer/yconalyzer-1.0.4.tar.bz2"
  sha256 "3b2bd33ffa9f6de707c91deeb32d9e9a56c51e232be5002fbed7e7a6373b4d5b"

  bottle do
    cellar :any
    sha256 "0425db9794e242424ce15c56cc1c5c0aa4cba2ea91bd96f2cc6960db62387f8e" => :mavericks
    sha256 "2d1477201d70504d4ecad48dd27b4e49c5b7c2c4535eb0f761d7646ae9ca89c5" => :mountain_lion
    sha256 "d4f646f82389d1ff7b0fb9a592a648cd1be522569af340069245668e06a5e1bb" => :lion
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
