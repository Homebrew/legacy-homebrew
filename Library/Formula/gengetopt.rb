require 'formula'

class Gengetopt < Formula
  url 'http://ftpmirror.gnu.org/gengetopt/gengetopt-2.22.5.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/gengetopt/gengetopt-2.22.5.tar.gz'
  homepage 'http://www.gnu.org/software/gengetopt/'
  md5 'a2168a480e49456451af83aa4618a529'

  def patches
    # patches to fix conflicting struct definitions
    # upstream issue: http://savannah.gnu.org/bugs/index.php?34430
    DATA
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"

    ENV.deparallelize
    system "make install"
  end
end

__END__
diff --git a/doc/main1.cc b/doc/main1.cc
index e6e727e..838d2ae 100644
--- a/doc/main1.cc
+++ b/doc/main1.cc
@@ -2,6 +2,10 @@
 /* we try to use gengetopt generated file in a C++ program */
 /* we don't use autoconf and automake vars */
 
+#ifdef HAVE_CONFIG_H
+#include "config.h"
+#endif
+
 #include <iostream>
 #include "stdlib.h"
 
diff --git a/src/acceptedvalues.cpp b/src/acceptedvalues.cpp
index 792908b..1ecb10f 100644
--- a/src/acceptedvalues.cpp
+++ b/src/acceptedvalues.cpp
@@ -10,6 +10,10 @@
 //
 //
 
+#ifdef HAVE_CONFIG_H
+#include "config.h"
+#endif
+
 #include <sstream>
 
 #include "acceptedvalues.h"
diff --git a/src/fileutils.cpp b/src/fileutils.cpp
index d97782c..33eecde 100644
--- a/src/fileutils.cpp
+++ b/src/fileutils.cpp
@@ -10,6 +10,10 @@
 //
 //
 
+#ifdef HAVE_CONFIG_H
+#include "config.h"
+#endif
+
 #include <cstdio>
 #include <cstdlib>
 #include <cstring>
