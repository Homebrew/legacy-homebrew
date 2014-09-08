require 'formula'

class Libxspf < Formula
  homepage 'http://libspiff.sourceforge.net/'
  url 'http://downloads.xiph.org/releases/xspf/libxspf-1.2.0.tar.bz2'
  sha1 '23bbc0573636928210f42699029941dd06b20a1d'

  bottle do
    cellar :any
    sha1 "d858c927da52a6405c92ad6aa6e27243b10be5b8" => :mavericks
    sha1 "129184060997e8de693d05353a17186eedeb6bd7" => :mountain_lion
    sha1 "8fabe7ae1a7ee2685207f67b33aee57d06697a1e" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'cpptest'
  depends_on 'uriparser'

  # Fix build against clang and GCC 4.7+
  # http://git.xiph.org/?p=libxspf.git;a=commit;h=7f1f68d433f03484b572657ff5df47bba1b03ba6
  patch :DATA

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
diff --git a/examples/read/read.cpp b/examples/read/read.cpp
index 411f892..b66a25c 100644
--- a/examples/read/read.cpp
+++ b/examples/read/read.cpp
@@ -43,6 +43,7 @@
 #include <cstdio>
 #include <cstdlib> // MAX_PATH
 #include <climits> // PATH_MAX
+#include <unistd.h>
 
 
 #if defined(__WIN32__) || defined(WIN32)
