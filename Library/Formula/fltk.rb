require 'formula'

class Fltk < Formula
  homepage 'http://www.fltk.org/'
  url 'http://ftp.easysw.com/pub/fltk/1.3.0/fltk-1.3.0-source.tar.gz'
  md5 '44d5d7ba06afdd36ea17da6b4b703ca3'

  devel do
    url 'http://ftp.easysw.com/pub/fltk/snapshots/fltk-1.3.x-r9327.tar.bz2'
    md5 '3205e5da58069ec7a1e487e6941cccd4'
    version '1.3.x-r9327'
  end

  depends_on :libpng
  depends_on 'jpeg'

  fails_with :clang do
    build 318
    cause "http://llvm.org/bugs/show_bug.cgi?id=10338"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-threads"
    system "make install"
  end
  
  # patch to fix change in scandir invocation, issue #13649
  def patches 
    DATA
  end
  
end

__END__
diff --git a/src/filename_list.cxx b/src/filename_list.cxx
index 6434d67..6bc126b 100644
--- a/src/filename_list.cxx
+++ b/src/filename_list.cxx
@@ -104,7 +104,7 @@ int fl_filename_list(const char *d, dirent ***list,
 #ifndef HAVE_SCANDIR
   // This version is when we define our own scandir
   int n = fl_scandir(dirloc, list, 0, sort);
-#elif defined(HAVE_SCANDIR_POSIX) && !defined(__APPLE__)
+#elif defined(HAVE_SCANDIR_POSIX) || defined(__APPLE__)
   // POSIX (2008) defines the comparison function like this:
   int n = scandir(dirloc, list, 0, (int(*)(const dirent **, const dirent **))sort);
 #elif defined(__osf__)
