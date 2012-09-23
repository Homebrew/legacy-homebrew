require 'formula'

class Devil < Formula
  url 'http://downloads.sourceforge.net/project/openil/DevIL/1.7.8/DevIL-1.7.8.tar.gz'
  homepage 'http://sourceforge.net/projects/openil/'
  sha1 'bc27e3e830ba666a3af03548789700d10561fcb1'

  depends_on :libpng
  depends_on 'jpeg'

  # see http://sourceforge.net/tracker/?func=detail&aid=3404133&group_id=4470&atid=104470
  # also, even with -std=gnu99 removed from the configure script,
  # devil fails to build with clang++ while compiling il_exr.cpp
  fails_with :clang do
    build 421
    cause "invalid -std=gnu99 flag while building C++"
  end

  # fix compilation issue for iluc.c
  def patches; DATA; end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-ILU",
                          "--enable-ILUT"
    system "make install"
  end
end

__END__
--- a/src-ILU/ilur/ilur.c   2009-03-08 08:10:12.000000000 +0100
+++ b/src-ILU/ilur/ilur.c  2010-09-26 20:01:45.000000000 +0200
@@ -1,6 +1,7 @@
 #include <string.h>
 #include <stdio.h>
-#include <malloc.h>
+#include <stdlib.h>
+#include "sys/malloc.h"

 #include <IL/il.h>
 #include <IL/ilu.h>

