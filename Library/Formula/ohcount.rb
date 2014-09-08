require 'formula'

class Ohcount < Formula
  homepage 'https://github.com/blackducksw/ohcount'
  url 'https://github.com/blackducksw/ohcount/archive/3.0.0.tar.gz'
  sha1 '7f3fce48bf2a522c5262215699c36625ca6d3d33'

  head do
    url 'https://github.com/blackducksw/ohcount.git'
    depends_on 'libmagic'
  end

  depends_on 'ragel'
  depends_on 'pcre'

  patch :DATA

  def install
    # find Homebrew's libpcre
    ENV.append 'LDFLAGS', "-L#{HOMEBREW_PREFIX}/lib"

    system "./build", "ohcount"
    bin.install 'bin/ohcount'
  end

  test do
    path = testpath/"test.rb"
    path.write "# comment\n puts\n puts\n"
    stats = `#{bin}/ohcount -i #{path}`.split("\n")[-1]
    assert_equal 0, $?.exitstatus
    assert_equal ["ruby", "2", "1", "33.3%"], stats.split[0..3]
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
