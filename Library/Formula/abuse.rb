require 'formula'

class AbuseGameData <Formula
  url 'http://abuse.zoy.org/raw-attachment/wiki/Downloads/abuse-data-2.00.tar.gz'
  md5 '2b857668849b2dc7cd29cdd84a33c19e'
end

class Abuse <Formula
  url 'svn://svn.zoy.org/abuse/abuse/trunk'
  homepage 'http://abuse.zoy.org/'
  version 'trunk'

  depends_on 'pkg-config'
  depends_on 'sdl'
  depends_on 'libvorbis'

  def patches
    # * Add SDL.m4 to aclocal includes
    # * Re-enable OpenGL detection
    # * Don't try to include malloc.h
    DATA
  end

  def startup_script
      return <<-END
#!/bin/bash
#{libexec}/abuse -datadir #{libexec} $*
END
  end

  def install
    # Copy the data files
    AbuseGameData.new.brew { libexec.install Dir["*"] }

    system "./bootstrap"
    system "./configure", "--prefix=#{prefix}", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-sdltest",
                          "--with-sdl-prefix=#{HOMEBREW_PREFIX}"

    # Use Framework OpenGL, not libGl
    %w[ . src src/imlib src/lisp src/net src/sdlport ].each do |p|
      inreplace "#{p}/Makefile", '-lGL', '-framework OpenGL'
    end

    system "make"
    libexec.install "src/abuse"
    # Use a startup script to find the game data
    (bin+'abuse').write startup_script
  end

  def caveats
    "Game settings and saves will be written to the ~/.abuse folder."
  end
end


__END__
diff --git a/bootstrap b/bootstrap
index b22c332..7c03039 100755
--- a/bootstrap
+++ b/bootstrap
@@ -116,7 +116,7 @@ if test "$libtool" = "yes"; then
   fi
 fi
 
-aclocal${amvers} ${aclocalflags}
+aclocal${amvers} ${aclocalflags} -I /usr/local/share/aclocal
 autoconf${acvers}
 if test "$header" = "yes"; then
   autoheader${acvers}
diff --git a/configure.ac b/configure.ac
index 52d55af..c466c4f 100644
--- a/configure.ac
+++ b/configure.ac
@@ -65,8 +65,7 @@ AC_TRY_COMPILE([
     #ifdef WIN32
     #include <windows.h>
     #elif defined(__APPLE__) && defined(__MACH__)
-/*    #include <OpenGL/gl.h>*/
-    #error	/* Error so the compile fails on OSX */
+    #include <OpenGL/gl.h>
     #else
     #include <GL/gl.h>
     #endif
diff --git a/src/compiled.cpp b/src/compiled.cpp
index 3b8047c..f944788 100644
--- a/src/compiled.cpp
+++ b/src/compiled.cpp
@@ -10,7 +10,10 @@
 #include "config.h"
 
 #include <string.h>
+
+#if !defined(__APPLE__)
 #include <malloc.h>
+#endif
 
 #include "lisp.hpp"
 #include "macs.hpp"
diff --git a/src/sdlport/setup.cpp b/src/sdlport/setup.cpp
index c3bd9d6..43db2a7 100644
--- a/src/sdlport/setup.cpp
+++ b/src/sdlport/setup.cpp
@@ -24,6 +24,12 @@
 #include <sys/stat.h>
 #include <signal.h>
 #include <SDL.h>
+
+#ifdef __APPLE__
+/* This is needed if ! HAVE_OPENGL */
+#include <CoreFoundation/CoreFoundation.h>
+#endif
+
 #ifdef HAVE_OPENGL
 #ifdef __APPLE__
 #include <Carbon/Carbon.h>
