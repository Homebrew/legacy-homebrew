require 'formula'

class Devil < Formula
  url 'http://downloads.sourceforge.net/project/openil/DevIL/1.7.8/DevIL-1.7.8.tar.gz'
  homepage 'http://sourceforge.net/projects/openil/'
  md5 '7918f215524589435e5ec2e8736d5e1d'

  depends_on 'jpeg'
  depends_on 'libtiff'
  depends_on 'little-cms'
  depends_on 'jasper'

  # fix compilation issue for iluc.c
  def patches; DATA; end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--enable-ILU"
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

