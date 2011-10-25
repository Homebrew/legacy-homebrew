require 'formula'

# need to have
# GMSGFMT=/usr/local/Cellar/gettext/0.18.1.1/bin/msgfmt
# in environment before configure

class Libqalculate < Formula
  url 'http://sourceforge.net/projects/qalculate/files/libqalculate/libqalculate-0.9.7/libqalculate-0.9.7.tar.gz'
  depends_on 'cln'
  depends_on 'readline'
  homepage 'http://qalculate.sourceforge.net'
  md5 'a1507ab862f4ad9852788619aada35cd'

  def patches
    # fixes incorrect malloc include path
    DATA
  end

  def install
    # ENV['GMSGFMT']=/usr/local/Cellar/gettext/0.18.1.1/bin/msgfmt
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
diff -u a/src/qalc.cc b/src/qalc.cc
--- a/src/qalc.cc 2011-10-14 08:23:05.000000000 -0700
+++ b/src/qalc.cc	2011-10-14 08:12:50.000000000 -0700
@@ -16,7 +16,7 @@
 #include <time.h>
 #include <pthread.h>
 #include <dirent.h>
-#include <malloc.h>
+#include <malloc/malloc.h>
 #include <stdio.h>
 #include <vector>
 #include <glib.h>
