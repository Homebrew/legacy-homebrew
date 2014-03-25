require 'formula'

class Squashfs < Formula
  homepage 'http://squashfs.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/squashfs/squashfs/squashfs4.2/squashfs4.2.tar.gz'
  sha256 'd9e0195aa922dbb665ed322b9aaa96e04a476ee650f39bbeadb0d00b24022e96'

  depends_on 'lzo'
  depends_on 'xz'

  fails_with :clang do
    build 318
  end

  # The instructions for this software say to do this on OS X
  patch :p0, :DATA

  def install
    cd 'squashfs-tools' do
      system "make XATTR_SUPPORT=0 EXTRA_CFLAGS=-std=gnu89 LZO_SUPPORT=1 LZO_DIR='#{HOMEBREW_PREFIX}' XZ_SUPPORT=1 XZ_DIR='#{HOMEBREW_PREFIX}' LZMA_XZ_SUPPORT=1"
      bin.install %w{mksquashfs unsquashfs}
    end
    doc.install %w{ACKNOWLEDGEMENTS CHANGES COPYING INSTALL OLD-READMEs PERFORMANCE.README README README-4.2}
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
@@ -29,7 +29,7 @@
 #include "compressor.h"
 #include "xattr.h"
 
-#include <sys/sysinfo.h>
+#include <sys/sysctl.h>
 #include <sys/types.h>
 
 struct cache *fragment_cache, *data_cache;
@@ -1195,7 +1196,7 @@
 			int match = use_regex ?
 				regexec(path->name[i].preg, name, (size_t) 0,
 				NULL, 0) == 0 : fnmatch(path->name[i].name,
-				name, FNM_PATHNAME|FNM_PERIOD|FNM_EXTMATCH) ==
+				name, FNM_PATHNAME|FNM_PERIOD) ==
 				0;
 			if(match && path->name[i].paths == NULL)
 				/*
