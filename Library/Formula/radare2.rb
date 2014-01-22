require 'formula'

class Radare2 < Formula
  homepage 'http://radare.org'
  url 'http://radare.org/get/radare2-0.9.6.tar.xz'
  sha1 'a12a2de9588d9925d32e1fb2e1942e491c602358'

  head 'http://radare.org/hg/radare2', :using => :hg

  depends_on 'libewf'
  depends_on 'libmagic'
  depends_on 'gmp'
  depends_on 'lua'

  # Fixes build on Lion and Mountain Lion where clang needs stdtypes.h for
  # uint32_t.
  def patches
    DATA
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end

__END__
diff -aur radare2-0.9.6.orig/libr/util/sys.c radare2-0.9.6/libr/util/sys.c
--- radare2-0.9.6.orig/libr/util/sys.c	2014-02-18 20:40:40.000000000 +0100
+++ radare2-0.9.6/libr/util/sys.c	2014-02-18 20:41:48.000000000 +0100
@@ -1,6 +1,7 @@
 /* radare - LGPL - Copyright 2009-2013 - pancake */

 #include <sys/types.h>
+#include <stdint.h>
 #include <dirent.h>
 #include <r_types.h>
 #include <r_util.h>
