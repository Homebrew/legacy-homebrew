require 'formula'

class Bindfs < Formula
  homepage 'http://bindfs.org/'

  stable do
    url "http://bindfs.org/downloads/bindfs-1.12.3.tar.gz"
    sha1 "fafdf47d9461dcad385d091b2732f97ffac67079"

    # Use lutimes() instead of ultimensat() to fix OS X compilation. Fixed upstream.
    patch :DATA
  end

  head "https://github.com/mpartel/bindfs.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "osxfuse"

  def install
    system "./autogen.sh", "--disable-debug", "--disable-dependency-tracking",
                           "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/bindfs", "-V"
  end
end

__END__
diff --git a/configure.ac b/configure.ac
index 6e45a78..085eeed 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1,7 +1,7 @@
 AC_INIT([bindfs],[1.12.3],[martin.partel@gmail.com])
 
 AM_INIT_AUTOMAKE([foreign])
-AM_CONFIG_HEADER(config.h)
+AC_CONFIG_HEADERS([config.h])
 
 AC_PROG_CC
 AC_LANG(C)
@@ -31,6 +31,8 @@ if test x"$with_core_foundation" == "xyes" ; then
 	LDFLAGS="${LDFLAGS} -framework CoreFoundation"
 fi
 
+AM_CONDITIONAL(BUILD_OS_IS_DARWIN, [test x"$build_os" = darwin])
+
 my_CPPFLAGS="-D_REENTRANT -D_FILE_OFFSET_BITS=64 -DFUSE_USE_VERSION=26"
 my_CFLAGS="$my_CFLAGS -Wall"
 my_LDFLAGS="-pthread"
@@ -38,7 +40,8 @@ AC_SUBST([my_CPPFLAGS])
 AC_SUBST([my_CFLAGS])
 AC_SUBST([my_LDFLAGS])
 
-# Check for xattrs
+# Checks for platform-specific stuff
+AC_CHECK_FUNCS([lutimes utimensat])
 AC_CHECK_FUNCS([setxattr getxattr listxattr removexattr])
 AC_CHECK_FUNCS([lsetxattr lgetxattr llistxattr lremovexattr])
 
diff --git a/src/bindfs.c b/src/bindfs.c
index 9348b2c..b584d32 100644
--- a/src/bindfs.c
+++ b/src/bindfs.c
@@ -34,6 +34,10 @@
 /* For >= 500 for pread/pwrite and readdir_r; >= 700 for utimensat */
 #define _XOPEN_SOURCE 700
 
+#if !HAVE_UTIMENSAT && HAVE_LUTIMES
+#define _BSD_SOURCE
+#endif
+
 #include <stdlib.h>
 #include <stddef.h>
 #include <stdio.h>
@@ -45,6 +49,7 @@
 #ifdef HAVE_SYS_STAT_H
 #include <sys/stat.h>
 #endif
+#include <sys/time.h>
 #include <sys/statvfs.h>
 #include <unistd.h>
 #include <fcntl.h>
@@ -690,13 +695,25 @@ static int bindfs_ftruncate(const char *path, off_t size,
     return 0;
 }
 
-static int bindfs_utimens(const char *path, const struct timespec tv[2])
+static int bindfs_utimens(const char *path, const struct timespec ts[2])
 {
     int res;
 
     path = process_path(path);
 
-    res = utimensat(settings.mntsrc_fd, path, tv, AT_SYMLINK_NOFOLLOW);
+#ifdef HAVE_UTIMENSAT
+    res = utimensat(settings.mntsrc_fd, path, ts, AT_SYMLINK_NOFOLLOW);
+#elif HAVE_LUTIMES
+    struct timeval tv[2];
+    tv[0].tv_sec = ts[0].tv_sec;
+    tv[0].tv_usec = ts[0].tv_nsec / 1000;
+    tv[1].tv_sec = ts[1].tv_sec;
+    tv[1].tv_usec = ts[1].tv_nsec / 1000;
+    res = lutimes(path, tv);
+#else
+#error "No symlink-compatible utime* function available."
+#endif
+
     if (res == -1)
         return -errno;
 
diff --git a/tests/Makefile.am b/tests/Makefile.am
index 8fc80ea..eca8563 100644
--- a/tests/Makefile.am
+++ b/tests/Makefile.am
@@ -1,4 +1,6 @@
 
+UNAME_S := $(shell uname -s)
+
 noinst_PROGRAMS = readdir_inode utimens_nofollow
 readdir_inode_SOURCES = readdir_inode.c
 utimens_nofollow_SOURCES = utimens_nofollow.c
diff --git a/tests/test_bindfs.rb b/tests/test_bindfs.rb
index 6e95020..741e75f 100755
--- a/tests/test_bindfs.rb
+++ b/tests/test_bindfs.rb
@@ -371,7 +371,7 @@ root_testenv("", :title => "setgid directories") do
     assert { File.stat('mnt/dir/file').gid == $nogroup_gid }
 end
 
-root_testenv("", :title => "utimens on symlinks") do
+testenv("", :title => "utimens on symlinks") do
     touch('mnt/file')
     Dir.chdir "mnt" do
       system('ln -sf file link')
@@ -380,7 +380,7 @@ root_testenv("", :title => "utimens on symlinks") do
     system("#{$tests_dir}/utimens_nofollow mnt/link 12 34 56 78")
     raise "Failed to run utimens_nofollow: #{$?.inspect}" unless $?.success?
     
-    assert { File.lstat('mnt/link').atime.to_i < 100 }
+    assert { File.lstat('mnt/link').atime.to_i < 50 }
     assert { File.lstat('mnt/link').mtime.to_i < 100 }
     assert { File.lstat('mnt/file').atime.to_i > 100 }
     assert { File.lstat('mnt/file').mtime.to_i > 100 }
diff --git a/tests/utimens_nofollow.c b/tests/utimens_nofollow.c
index ced9b5f..f8f6401 100644
--- a/tests/utimens_nofollow.c
+++ b/tests/utimens_nofollow.c
@@ -1,23 +1,25 @@
 
-#define _BSD_SOURCE /* For atoll */
+#define _BSD_SOURCE /* For atoll and lutimes */
 
+#include <config.h>
 #include <stdlib.h>
 #include <stdio.h>
 #include <unistd.h>
 #include <sys/types.h>
 #include <sys/stat.h>
+#include <sys/time.h>
 #include <fcntl.h>
 #include <errno.h>
 
 int main(int argc, char* argv[])
 {
-    struct timespec times[2];
-    
     if (argc != 6) {
         fprintf(stderr, "Usage: utimens_nofollow path atime atime_nsec mtime mtime_nsec\n");
         return 1;
     }
-    
+
+#ifdef HAVE_UTIMENSAT
+    struct timespec times[2];
     times[0].tv_sec = (time_t)atoll(argv[2]);
     times[0].tv_nsec = atoll(argv[3]);
     times[1].tv_sec = (time_t)atoll(argv[4]);
@@ -27,6 +29,19 @@ int main(int argc, char* argv[])
         perror("failed to utimensat the given path");
         return 2;
     }
-    
+#elif HAVE_LUTIMES
+    struct timeval times[2];
+    times[0].tv_sec = (time_t)atoll(argv[2]);
+    times[0].tv_usec = (suseconds_t)atoll(argv[3]) / 1000;
+    times[1].tv_sec = (time_t)atoll(argv[4]);
+    times[1].tv_usec = (suseconds_t)atoll(argv[5]) / 1000;
+    if (lutimes(argv[1], times) == -1) {
+        perror("failed to lutimes the given path");
+        return 2;
+    }
+#else
+#error "No symlink-compatible utime* function available."
+#endif
+
     return 0;
 }
