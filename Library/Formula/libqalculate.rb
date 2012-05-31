require 'formula'

class Libqalculate < Formula
  homepage 'http://qalculate.sourceforge.net/'
  url 'http://sourceforge.net/projects/qalculate/files/libqalculate/libqalculate-0.9.7/libqalculate-0.9.7.tar.gz'
  md5 'a1507ab862f4ad9852788619aada35cd'

  depends_on 'cln'
  depends_on 'glib'
  depends_on 'gnuplot'
  depends_on 'gettext'
  depends_on 'readline'
  depends_on 'wget'

  # Patches against version 0.9.7, should not be needed in the future
  def patches; DATA; end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/qalc", "(2+2)/4 hours to minutes"
  end
end

__END__
diff -ur a/src/defs2doc.cc b/src/defs2doc.cc
--- a/src/defs2doc.cc 2009-12-02 14:24:28.000000000 -0600
+++ b/src/defs2doc.cc 2012-01-10 18:47:50.000000000 -0600
@@ -16,7 +16,9 @@
 #include <time.h>
 #include <pthread.h>
 #include <dirent.h>
+#if !defined(__APPLE__)
 #include <malloc.h>
+#endif
 #include <stdio.h>
 #include <vector>
 #include <glib.h>
diff -ur a/src/qalc.cc b/src/qalc.cc
--- a/src/qalc.cc 2010-01-05 09:17:29.000000000 -0600
+++ b/src/qalc.cc 2012-01-10 18:47:42.000000000 -0600
@@ -16,7 +16,9 @@
 #include <time.h>
 #include <pthread.h>
 #include <dirent.h>
+#if !defined(__APPLE__)
 #include <malloc.h>
+#endif
 #include <stdio.h>
 #include <vector>
 #include <glib.h>
