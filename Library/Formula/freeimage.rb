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
  url 'https://downloads.sourceforge.net/project/freeimage/Source%20Distribution/3.15.4/FreeImage3154.zip',
        :using => FreeimageHttpDownloadStrategy
  version '3.15.4'
  sha1 '1d30057a127b2016cf9b4f0f8f2ba92547670f96'

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
index f4336d2..15e8c00 100644
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
@@ -27,8 +28,8 @@ endif

 TARGET  = freeimageplus
 STATICLIB = lib$(TARGET).a
-SHAREDLIB = lib$(TARGET)-$(VER_MAJOR).$(VER_MINOR).so
-LIBNAME	= lib$(TARGET).so
+SHAREDLIB = lib$(TARGET)-$(VER_MAJOR).$(VER_MINOR).dylib
+LIBNAME	= lib$(TARGET).dylib
 VERLIBNAME = $(LIBNAME).$(VER_MAJOR)
 HEADER = Source/FreeImage.h
 HEADERFIP = Wrapper/FreeImagePlus/FreeImagePlus.h
@@ -40,7 +41,7 @@ all: dist

 dist: FreeImage
 	cp *.a Dist
-	cp *.so Dist
+	cp *.dylib Dist
 	cp Source/FreeImage.h Dist
	cp Wrapper/FreeImagePlus/FreeImagePlus.h Dist

@@ -59,14 +60,15 @@ $(STATICLIB): $(MODULES)
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
index 0c967b8..e50ed7f 100644
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
@@ -27,8 +28,8 @@ endif

 TARGET  = freeimage
 STATICLIB = lib$(TARGET).a
-SHAREDLIB = lib$(TARGET)-$(VER_MAJOR).$(VER_MINOR).so
-LIBNAME	= lib$(TARGET).so
+SHAREDLIB = lib$(TARGET)-$(VER_MAJOR).$(VER_MINOR).dylib
+LIBNAME	= lib$(TARGET).dylib
 VERLIBNAME = $(LIBNAME).$(VER_MAJOR)
 HEADER = Source/FreeImage.h

@@ -40,7 +41,7 @@ all: dist

 dist: FreeImage
	cp *.a Dist
-	cp *.so Dist
+	cp *.dylib Dist
	cp Source/FreeImage.h Dist

 dos2unix:
@@ -58,13 +59,13 @@ $(STATICLIB): $(MODULES)
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
index edb8b10..3ecf3e0 100755
--- a/Source/OpenEXR/IlmImf/ImfAutoArray.h
+++ b/Source/OpenEXR/IlmImf/ImfAutoArray.h
@@ -44,6 +44,7 @@
 //
 //-----------------------------------------------------------------------------

+#include <cstring>
 #include "OpenEXRConfig.h"

 namespace Imf {
