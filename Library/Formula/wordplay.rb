require 'formula'

class Wordplay < Formula
  homepage 'http://hsvmovies.com/static_subpages/personal_orig/wordplay/index.html'
  url 'http://hsvmovies.com/static_subpages/personal_orig/wordplay/wordplay722.tar.Z'
  sha1 '629b4a876b6be966be7ddde7ccdfaa89fc226942'

  def patches
    # Fixes compiler warnings on Darwin
    { :p0 => DATA }
  end

  def install
    system "make"
    system "install -d -m 755 #{share}/wordplay"
    system "install -d -m 755 #{bin}"
    system "install -m 755 wordplay #{bin}/wordplay"
    system "install -m 644 readme #{share}/wordplay/readme"
    system "install -m 644 words721.txt #{share}/wordplay/words721.txt"
  end

end

__END__

--- wordplay.c.orig	2012-08-19 11:36:39.000000000 -0700
+++ wordplay.c	2012-08-19 11:36:59.000000000 -0700
@@ -136,6 +136,7 @@
 */
 
 #include <stdio.h>
+#include <stdlib.h>
 #include <string.h>
 #include <ctype.h>
 
