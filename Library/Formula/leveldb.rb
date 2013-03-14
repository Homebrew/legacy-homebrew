require 'formula'

class Leveldb < Formula
  homepage 'https://code.google.com/p/leveldb/'
  url 'https://leveldb.googlecode.com/files/leveldb-1.9.0.tar.gz'
  sha1 '4d832277120912211998a2334fb975b995d51885'

  depends_on 'snappy' => :build

  # tcmalloc causes segfault during linking on OSX
  # https://code.google.com/p/leveldb/issues/detail?id=131
  def patches
    DATA
  end

  def install
    system "make"
    system "make leveldbutil"
    include.install "include/leveldb"
    bin.install 'leveldbutil'
    lib.install 'libleveldb.a'
    lib.install 'libleveldb.dylib.1.9' => 'libleveldb.1.9.dylib'
    lib.install_symlink lib/'libleveldb.1.9.dylib' => 'libleveldb.dylib'
    lib.install_symlink lib/'libleveldb.1.9.dylib' => 'libleveldb.1.dylib'
  end
end

__END__
--- a/build_detect_platform	2013-01-07 16:07:29.000000000 -0500
+++ b/build_detect_platform	2013-02-16 14:28:06.000000000 -0500
@@ -178,13 +178,6 @@
         PLATFORM_LIBS="$PLATFORM_LIBS -lsnappy"
     fi

-    # Test whether tcmalloc is available
-    $CXX $CXXFLAGS -x c++ - -o /dev/null -ltcmalloc 2>/dev/null  <<EOF
-      int main() {}
-EOF
-    if [ "$?" = 0 ]; then
-        PLATFORM_LIBS="$PLATFORM_LIBS -ltcmalloc"
-    fi
 fi

 PLATFORM_CCFLAGS="$PLATFORM_CCFLAGS $COMMON_FLAGS"
