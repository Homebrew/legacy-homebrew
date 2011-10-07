require 'formula'

class Ohcount < Formula
  url 'http://downloads.sourceforge.net/project/ohcount/ohcount-3.0.0.tar.gz'
  homepage 'http://sourceforge.net/apps/trac/ohcount/'
  md5 '08f97d01adde8b45635abfe93f8a717a'

  depends_on 'ragel'
  depends_on 'pcre'

  def patches
    DATA
  end

  def install
    system "./build", "ohcount"
    bin.install 'bin/ohcount'
  end
end

__END__
--- a/build
+++ b/build
@@ -29,7 +29,7 @@ else
   INC_DIR=/opt/local/include
   LIB_DIR=/opt/local/lib
   # You shouldn't have to change the following.
-  CFLAGS="-fno-common -g"
+  #CFLAGS="-fno-common -g"
   WARN="-Wall -Wno-parentheses"
   SHARED="-dynamiclib -L$LIB_DIR -lpcre"
   SHARED_NAME=libohcount.dylib
@@ -38,7 +38,7 @@ else
 fi
 
 # C compiler and flags
-cc="gcc -fPIC -g $CFLAGS $WARN -I$INC_DIR -L$LIB_DIR"
+cc="$CC $CFLAGS -O0 $WARN $CPPFLAGS $LDFLAGS"
 
 # Ohcount source files
 files="src/sourcefile.c \
