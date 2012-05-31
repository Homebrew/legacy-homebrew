require 'formula'

class Squashfs < Formula
  homepage 'http://squashfs.sourceforge.net/'
  url 'http://sourceforge.net/projects/squashfs/files/squashfs/squashfs4.0/squashfs4.0.tar.gz'
  md5 'a3c23391da4ebab0ac4a75021ddabf96'

  fails_with :clang do
    build 318
  end

  def patches
   { :p0 => DATA }
  end

  def install
    cd 'squashfs-tools' do
      system "make"
      bin.install %w{mksquashfs unsquashfs}
    end

    doc.install %w{ACKNOWLEDGEMENTS CHANGES COPYING INSTALL OLD-READMEs PERFORMANCE.README README README-4.0}
  end
end

__END__

Originally from some internal notes:
  "cd squashfs-tools; sed -i.orig 's/\|FNM_EXTMATCH//' $(grep -l FNM_EXTMATCH *)"
  "cd squashfs-tools; sed -i.orig $'/#include \"unsquashfs.h\"/{i\\\n#include <sys/sysctl.h>\n}' unsquashfs.c"

diff -u squashfs-tools.orig/mksquashfs.c squashfs-tools/mksquashfs.c
--- squashfs-tools.orig/mksquashfs.c	2009-04-05 14:22:48.000000000 -0700
+++ squashfs-tools/mksquashfs.c	2011-11-17 17:51:31.000000000 -0800
@@ -3975,7 +3975,7 @@
 				regexec(path->name[i].preg, name, (size_t) 0,
 					NULL, 0) == 0 :
 				fnmatch(path->name[i].name, name,
-					FNM_PATHNAME|FNM_PERIOD|FNM_EXTMATCH) ==
+					FNM_PATHNAME|FNM_PERIOD) ==
 					 0;
 
 			if(match && path->name[i].paths == NULL) {
Only in squashfs-tools: mksquashfs.c.orig
diff -u squashfs-tools.orig/unsquashfs.c squashfs-tools/unsquashfs.c
--- squashfs-tools.orig/unsquashfs.c	2009-04-05 14:23:06.000000000 -0700
+++ squashfs-tools/unsquashfs.c	2011-11-17 17:51:44.000000000 -0800
@@ -21,6 +21,7 @@
  * unsquashfs.c
  */
 
+#include <sys/sysctl.h>
 #include "unsquashfs.h"
 #include "squashfs_swap.h"
 #include "squashfs_compat.h"
@@ -1195,7 +1196,7 @@
 			int match = use_regex ?
 				regexec(path->name[i].preg, name, (size_t) 0,
 				NULL, 0) == 0 : fnmatch(path->name[i].name,
-				name, FNM_PATHNAME|FNM_PERIOD|FNM_EXTMATCH) ==
+				name, FNM_PATHNAME|FNM_PERIOD) ==
 				0;
 			if(match && path->name[i].paths == NULL)
 				/*
