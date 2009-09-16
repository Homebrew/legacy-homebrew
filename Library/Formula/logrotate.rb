require 'brewkit'

class Logrotate <Formula
  @url='http://ftp.de.debian.org/debian/pool/main/l/logrotate/logrotate_3.7.8.orig.tar.gz'
  @homepage='http://packages.debian.org/testing/admin/logrotate'
  @md5='b3589bea6d8d5afc8a84134fddaae973'

  def deps
    LibraryDep.new 'popt'
  end

  def patches
    # these patches emerge from the logrotate patch. Recursively nice!
    debian_patches=['configparse.patch',
                    'datehack.patch',
                    'compressutime.patch',
                    'man-startcount.patch',
                    'dst.patch',
                    'dateext-504079.patch',
                    'rh-toolarge.patch',
                    'rh-curdir2.patch',
                    'copyloginfo-512152.patch',
                    'sharedscripts-519432.patch',
                    'chown-484762.patch',
                    'create-388608.patch',
                    'nofollow.patch',
                    'security-388608.patch'].collect {|p| "debian/patches/#{p}"}

    [
      DATA,
      "http://ftp.de.debian.org/debian/pool/main/l/logrotate/logrotate_3.7.8-4.diff.gz",
      *debian_patches
    ]
  end

  def install
    system "make"
    system "make", "install", "BASEDIR=#{prefix}"
  end
end


__END__
diff --git a/config.c b/config.c
index 4e650f1..be7905a 100644
--- a/config.c
+++ b/config.c
@@ -12,6 +12,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <sys/stat.h>
+#include <sys/syslimits.h>
 #include <time.h>
 #include <unistd.h>
 #include <assert.h>
diff --git a/logrotate.c b/logrotate.c
index 6427465..f0614a8 100644
--- a/logrotate.c
+++ b/logrotate.c
@@ -10,6 +10,7 @@
 #include <string.h>
 #include <sys/stat.h>
 #include <sys/wait.h>
+#include <sys/syslimits.h>
 #include <time.h>
 #include <unistd.h>
 #include <glob.h>
diff --git a/Makefile b/Makefile
index f110ab5..8e17dea 100644
--- a/Makefile
+++ b/Makefile
@@ -45,6 +45,14 @@ ifeq ($(OS_NAME),SunOS)
     endif
 endif
 
+# Darwin
+ifeq ($(OS_NAME),Darwin)
+    INSTALL = install
+    ifeq ($(BASEDIR),)
+        BASEDIR = /usr/local
+    endif
+endif
+
 # Red Hat Linux
 ifeq ($(OS_NAME),Linux)
     INSTALL = install
