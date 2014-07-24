require 'formula'

class FreeimageHttpDownloadStrategy < CurlDownloadStrategy
  def stage
    # need to convert newlines or patch chokes
    safe_system '/usr/bin/unzip', '-aaqq', @tarball_path
    chdir
  end
end

class Freeimage < Formula
  homepage 'http://sf.net/projects/freeimage'
  url 'https://downloads.sourceforge.net/project/freeimage/Source%20Distribution/3.16.0/FreeImage3160.zip',
        :using => FreeimageHttpDownloadStrategy
  version '3.16.0'
  sha1 'a70600d288fe5bd11131e85e6f857a93bb100ad8'

  option :universal

  patch :DATA

  def install
    ENV.universal_binary if build.universal?
    system "make", "-f", "Makefile.gnu"
    system "make", "-f", "Makefile.gnu", "install", "PREFIX=#{prefix}"
    system "make", "-f", "Makefile.fip"
    system "make", "-f", "Makefile.fip", "install", "PREFIX=#{prefix}"
  end
end

__END__
diff --git a/Makefile.fip b/Makefile.fip
index 6006221..e306d35 100644
--- a/Makefile.fip
+++ b/Makefile.fip
@@ -5,8 +5,9 @@ include fipMakefile.srcs
 
 # General configuration variables:
 DESTDIR ?= /
-INCDIR ?= $(DESTDIR)/usr/include
-INSTALLDIR ?= $(DESTDIR)/usr/lib
+PREFIX ?= /usr/local
+INCDIR ?= $(DESTDIR)$(PREFIX)/include
+INSTALLDIR ?= $(DESTDIR)$(PREFIX)/lib
 
 # Converts cr/lf to just lf
 DOS2UNIX = dos2unix
@@ -35,9 +36,9 @@ endif
 
 TARGET  = freeimageplus
 STATICLIB = lib$(TARGET).a
-SHAREDLIB = lib$(TARGET)-$(VER_MAJOR).$(VER_MINOR).so
-LIBNAME	= lib$(TARGET).so
-VERLIBNAME = $(LIBNAME).$(VER_MAJOR)
+SHAREDLIB = lib$(TARGET).$(VER_MAJOR).$(VER_MINOR).dylib
+LIBNAME	= lib$(TARGET).dylib
+VERLIBNAME = lib$(TARGET).$(VER_MAJOR).dylib
 HEADER = Source/FreeImage.h
 HEADERFIP = Wrapper/FreeImagePlus/FreeImagePlus.h
 
@@ -48,7 +49,7 @@ all: dist
 
 dist: FreeImage
 	cp *.a Dist
-	cp *.so Dist
+	cp *.dylib Dist
 	cp Source/FreeImage.h Dist
 	cp Wrapper/FreeImagePlus/FreeImagePlus.h Dist
 
@@ -67,14 +68,15 @@ $(STATICLIB): $(MODULES)
 	$(AR) r $@ $(MODULES)
 
 $(SHAREDLIB): $(MODULES)
-	$(CC) -s -shared -Wl,-soname,$(VERLIBNAME) $(LDFLAGS) -o $@ $(MODULES) $(LIBRARIES)
+	$(CXX) -dynamiclib -install_name $(LIBNAME) -current_version $(VER_MAJOR).$(VER_MINOR) -compatibility_version $(VER_MAJOR) $(LDFLAGS) -o $@ $(MODULES)
 
 install:
 	install -d $(INCDIR) $(INSTALLDIR)
-	install -m 644 -o root -g root $(HEADER) $(INCDIR)
-	install -m 644 -o root -g root $(HEADERFIP) $(INCDIR)
-	install -m 644 -o root -g root $(STATICLIB) $(INSTALLDIR)
-	install -m 755 -o root -g root $(SHAREDLIB) $(INSTALLDIR)
+	install -m 644 $(HEADER) $(INCDIR)
+	install -m 644 $(HEADERFIP) $(INCDIR)
+	install -m 644 $(STATICLIB) $(INSTALLDIR)
+	install -m 755 $(SHAREDLIB) $(INSTALLDIR)
+	ln -s $(SHAREDLIB) $(INSTALLDIR)/$(LIBNAME)
 
 clean:
 	rm -f core Dist/*.* u2dtmp* $(MODULES) $(STATICLIB) $(SHAREDLIB) $(LIBNAME)
diff --git a/Makefile.gnu b/Makefile.gnu
index 5f2c625..c98f44a 100644
--- a/Makefile.gnu
+++ b/Makefile.gnu
@@ -5,8 +5,9 @@ include Makefile.srcs
 
 # General configuration variables:
 DESTDIR ?= /
-INCDIR ?= $(DESTDIR)/usr/include
-INSTALLDIR ?= $(DESTDIR)/usr/lib
+PREFIX ?= /usr/local
+INCDIR ?= $(DESTDIR)$(PREFIX)/include
+INSTALLDIR ?= $(DESTDIR)$(PREFIX)/lib
 
 # Converts cr/lf to just lf
 DOS2UNIX = dos2unix
@@ -35,9 +36,9 @@ endif
 
 TARGET  = freeimage
 STATICLIB = lib$(TARGET).a
-SHAREDLIB = lib$(TARGET)-$(VER_MAJOR).$(VER_MINOR).so
-LIBNAME	= lib$(TARGET).so
-VERLIBNAME = $(LIBNAME).$(VER_MAJOR)
+SHAREDLIB = lib$(TARGET).$(VER_MAJOR).$(VER_MINOR).dylib
+LIBNAME	= lib$(TARGET).dylib
+VERLIBNAME = lib$(TARGET).$(VER_MAJOR).dylib
 HEADER = Source/FreeImage.h
 
 
@@ -48,7 +49,7 @@ all: dist
 
 dist: FreeImage
 	cp *.a Dist
-	cp *.so Dist
+	cp *.dylib Dist
 	cp Source/FreeImage.h Dist
 
 dos2unix:
@@ -66,13 +67,13 @@ $(STATICLIB): $(MODULES)
 	$(AR) r $@ $(MODULES)
 
 $(SHAREDLIB): $(MODULES)
-	$(CC) -s -shared -Wl,-soname,$(VERLIBNAME) $(LDFLAGS) -o $@ $(MODULES) $(LIBRARIES)
+	$(CXX) -dynamiclib -install_name $(LIBNAME) -current_version $(VER_MAJOR).$(VER_MINOR) -compatibility_version $(VER_MAJOR) $(LDFLAGS) -o $@ $(MODULES)
 
 install:
 	install -d $(INCDIR) $(INSTALLDIR)
-	install -m 644 -o root -g root $(HEADER) $(INCDIR)
-	install -m 644 -o root -g root $(STATICLIB) $(INSTALLDIR)
-	install -m 755 -o root -g root $(SHAREDLIB) $(INSTALLDIR)
+	install -m 644 $(HEADER) $(INCDIR)
+	install -m 644 $(STATICLIB) $(INSTALLDIR)
+	install -m 755 $(SHAREDLIB) $(INSTALLDIR)
 	ln -sf $(SHAREDLIB) $(INSTALLDIR)/$(VERLIBNAME)
 	ln -sf $(VERLIBNAME) $(INSTALLDIR)/$(LIBNAME)	
 #	ldconfig
diff --git a/Source/OpenEXR/IlmImf/ImfAutoArray.h b/Source/OpenEXR/IlmImf/ImfAutoArray.h
index 7b4533f..98bf458 100644
--- a/Source/OpenEXR/IlmImf/ImfAutoArray.h
+++ b/Source/OpenEXR/IlmImf/ImfAutoArray.h
@@ -44,6 +44,7 @@
 //
 //-----------------------------------------------------------------------------
 
+#include <cstring>
 #include "OpenEXRConfig.h"
 #if !defined(_WIN32) || defined(__MINGW32__)
 // needed for memset
