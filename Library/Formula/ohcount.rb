require 'formula'

class Ohcount <Formula
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
@@ -38,7 +38,7 @@ else
 fi
 
 # C compiler and flags
-cc="gcc -fPIC -g $CFLAGS $WARN -I$INC_DIR -L$LIB_DIR"
+cc="$CC -fPIC -g $CFLAGS $WARN $CPPFLAGS $LDFLAGS"
 
 # Ohcount source files
 files="src/sourcefile.c \
