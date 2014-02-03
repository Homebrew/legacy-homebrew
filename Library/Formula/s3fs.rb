require 'formula'

class S3fs < Formula
  homepage 'http://code.google.com/p/s3fs/'
  url 'https://github.com/s3fs-fuse/s3fs-fuse/archive/v1.76.tar.gz'
  sha1 '478aa3230b5d85bfe95d9962ee2f1d8cd35fa070'

  depends_on 'pkg-config' => :build
  depends_on :autoconf => :build
  depends_on :automake => :build
  depends_on 'osxfuse'

  def patches
    # Makes it work with OSXFUSE.
    DATA
  end

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end

  def caveats
    <<-EOS.undent
      Make sure to follow the directions given by `brew info osxfuse`
      before trying to use a FUSE-based filesystem.

      Also, be aware that s3fs has some caveats concerning S3 "directories"
      that have been created by other tools. See the following issue for
      details:

        http://code.google.com/p/s3fs/issues/detail?id=73
    EOS
  end
end

__END__
diff -u -r a/configure.ac b/configure.ac
--- a/configure.ac  2014-01-21 10:37:38.000000000 -0500
+++ b/configure.ac  2014-02-03 15:22:27.000000000 -0500
@@ -29,7 +29,7 @@
 
 CXXFLAGS="$CXXFLAGS -Wall -D_FILE_OFFSET_BITS=64"
 
-PKG_CHECK_MODULES([DEPS], [fuse >= 2.8.4 libcurl >= 7.0 libxml-2.0 >= 2.6 libcrypto >= 0.9])
+PKG_CHECK_MODULES([DEPS], [fuse >= 2.7.3 libcurl >= 7.0 libxml-2.0 >= 2.6 libcrypto >= 0.9])
 
 dnl malloc_trim function
 AC_CHECK_FUNCS(malloc_trim, , )
diff -u -r a/src/s3fs.cpp b/src/s3fs.cpp
--- a/src/s3fs.cpp  2014-01-21 10:37:38.000000000 -0500
+++ b/src/s3fs.cpp  2014-02-03 15:27:01.000000000 -0500
@@ -2615,9 +2615,9 @@
   }
 
   // Investigate system capabilities
-  if((unsigned int)conn->capable & FUSE_CAP_ATOMIC_O_TRUNC){
-     conn->want |= FUSE_CAP_ATOMIC_O_TRUNC;
-  }
+  // if((unsigned int)conn->capable & FUSE_CAP_ATOMIC_O_TRUNC){
+  //    conn->want |= FUSE_CAP_ATOMIC_O_TRUNC;
+  // }
   // cache
   if(is_remove_cache && !FdManager::DeleteCacheDirectory()){
     DPRNINFO("Could not inilialize cache directory.");
