require 'formula'

class Png2ico < Formula
  homepage 'http://www.winterdrache.de/freeware/png2ico/'
  url 'http://www.winterdrache.de/freeware/png2ico/data/png2ico-src-2002-12-08.tar.gz'
  sha1 '955004bee9a20f12b225aa01895762cbbafaeb28'
  revision 1

  depends_on 'libpng'

  # Fix build with recent clang
  patch :DATA

  def install
    inreplace 'Makefile', 'g++', '$(CXX)'
    system "make", "CPPFLAGS=#{ENV.cxxflags} #{ENV.cppflags} #{ENV.ldflags}"
    bin.install 'png2ico'
    man1.install 'doc/png2ico.1'
  end
end

__END__
diff --git a/png2ico.cpp b/png2ico.cpp
index 8fb87e4..9dedb97 100644
--- a/png2ico.cpp
+++ b/png2ico.cpp
@@ -34,6 +34,7 @@ Notes about transparent and inverted pixels:
 #include <cstdio>
 #include <vector>
 #include <climits>
+#include <cstdlib>
 
 #if __GNUC__ > 2
 #include <ext/hash_map>
