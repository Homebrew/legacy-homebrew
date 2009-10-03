require 'brewkit'

class AbuseGameData <Formula
  url 'http://abuse.zoy.org/raw/Downloads/abuse-data-2.00.tar.gz'
  md5 '2b857668849b2dc7cd29cdd84a33c19e'
end

class Abuse <Formula
  url 'svn://svn.zoy.org/abuse/abuse/trunk'
  homepage 'http://abuse.zoy.org/'
  version 'trunk'
  
  depends_on 'sdl'
  
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
    d = libexec
    AbuseGameData.new.brew { d.install Dir["*"] }
    

    system "./bootstrap"
    system "./configure", "--prefix=#{prefix}", "--disable-debug", 
                          "--disable-dependency-tracking"
    
    # Use Framework OpenGL, not libGl
    inreplace "Makefile",
      "LIBS =  -lm -L/usr/local/Cellar/sdl/1.2.13/lib -lSDLmain -lSDL -Wl,-framework,Cocoa  -lGL -lpthread",
      "LIBS =  -lm -L/usr/local/Cellar/sdl/1.2.13/lib -lSDLmain -lSDL -Wl,-framework,Cocoa -framework OpenGL -lpthread"
    
    inreplace "src/Makefile",
      "LIBS =  -lm -L/usr/local/Cellar/sdl/1.2.13/lib -lSDLmain -lSDL -Wl,-framework,Cocoa  -lGL -lpthread",
      "LIBS =  -lm -L/usr/local/Cellar/sdl/1.2.13/lib -lSDLmain -lSDL -Wl,-framework,Cocoa -framework OpenGL -lpthread"
    
    %w[imlib lisp net sdlport].each do |p|
      inreplace "src/#{p}/Makefile",
        "LIBS =  -lm -L/usr/local/Cellar/sdl/1.2.13/lib -lSDLmain -lSDL -Wl,-framework,Cocoa  -lGL -lpthread",
        "LIBS =  -lm -L/usr/local/Cellar/sdl/1.2.13/lib -lSDLmain -lSDL -Wl,-framework,Cocoa -framework OpenGL -lpthread"
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
