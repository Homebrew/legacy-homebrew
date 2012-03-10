require 'formula'

class FreeimageHttpDownloadStrategy < CurlDownloadStrategy
  def stage
    # need to convert newlines or patch chokes
    safe_system '/usr/bin/unzip', '-aaqq', @tarball_path
    chdir
  end
end

class Freeimage < Formula
  url 'http://downloads.sourceforge.net/project/freeimage/Source%20Distribution/3.15.1/FreeImage3151.zip',
        :using => FreeimageHttpDownloadStrategy
  version '3.15.1'
  md5 '450d2ff278690b0d1d7d7d58fad083cc'
  homepage 'http://sf.net/projects/freeimage'

  def patches
    DATA
  end

  def install
    system "gnumake -f Makefile.gnu"
    system "gnumake -f Makefile.gnu install PREFIX=#{prefix}"
    system "gnumake -f Makefile.fip"
    system "gnumake -f Makefile.fip install PREFIX=#{prefix}"
  end
end

__END__
--- old/Makefile.gnu	2010-12-06 23:37:20.000000000 -0800
+++ new/Makefile.gnu	2011-10-19 13:42:59.000000000 -0700
@@ -5,8 +5,9 @@
 
 # General configuration variables:
 DESTDIR ?= /
-INCDIR ?= $(DESTDIR)/usr/include
-INSTALLDIR ?= $(DESTDIR)/usr/lib
+PREFIX ?= /usr/local
+INCDIR ?= $(DESTDIR)$(PREFIX)/include
+INSTALLDIR ?= $(DESTDIR)$(PREFIX)/lib
 
 # Converts cr/lf to just lf
 DOS2UNIX = dos2unix
@@ -27,11 +28,10 @@
 
 TARGET  = freeimage
 STATICLIB = lib$(TARGET).a
-SHAREDLIB = lib$(TARGET)-$(VER_MAJOR).$(VER_MINOR).so
-LIBNAME	= lib$(TARGET).so
-VERLIBNAME = $(LIBNAME).$(VER_MAJOR)
+SHAREDLIB = lib$(TARGET).$(VER_MAJOR).$(VER_MINOR).dylib
+LIBNAME	= lib$(TARGET).dylib
 HEADER = Source/FreeImage.h
-
+LIBTOOL ?= libtool
 
 
 default: all
@@ -40,7 +40,7 @@
 
 dist: FreeImage
 	cp *.a Dist
-	cp *.so Dist
+	cp *.dylib Dist
 	cp Source/FreeImage.h Dist
 
 dos2unix:
@@ -58,16 +58,14 @@
	$(AR) r $@ $(MODULES)
 
 $(SHAREDLIB): $(MODULES)
-	$(CC) -s -shared -Wl,-soname,$(VERLIBNAME) $(LDFLAGS) -o $@ $(MODULES) $(LIBRARIES)
+	$(CXX) -dynamiclib -install_name $(LIBNAME) -current_version $(VER_MAJOR).$(VER_MINOR) -compatibility_version $(VER_MAJOR) -o $@ $(MODULES)

 install:
	install -d $(INCDIR) $(INSTALLDIR)
-	install -m 644 -o root -g root $(HEADER) $(INCDIR)
-	install -m 644 -o root -g root $(STATICLIB) $(INSTALLDIR)
-	install -m 755 -o root -g root $(SHAREDLIB) $(INSTALLDIR)
-	ln -sf $(SHAREDLIB) $(INSTALLDIR)/$(VERLIBNAME)
-	ln -sf $(VERLIBNAME) $(INSTALLDIR)/$(LIBNAME)	
-	ldconfig
+	install -m 644 $(HEADER) $(INCDIR)
+	install -m 644 $(STATICLIB) $(INSTALLDIR)
+	install -m 755 $(SHAREDLIB) $(INSTALLDIR)
+	ln -sf $(SHAREDLIB) $(INSTALLDIR)/$(LIBNAME)

 clean:
	rm -f core Dist/*.* u2dtmp* $(MODULES) $(STATICLIB) $(SHAREDLIB) $(LIBNAME)
--- old/Makefile.fip	2011-10-19 11:20:03.000000000 -0700
+++ new/Makefile.fip	2011-10-19 11:24:01.000000000 -0700
@@ -5,8 +5,9 @@

 # General configuration variables:
 DESTDIR ?= /
-INCDIR ?= $(DESTDIR)/usr/include
-INSTALLDIR ?= $(DESTDIR)/usr/lib
+PREFIX ?= /usr/local
+INCDIR ?= $(DESTDIR)$(PREFIX)/include
+INSTALLDIR ?= $(DESTDIR)$(PREFIX)/lib

 # Converts cr/lf to just lf
 DOS2UNIX = dos2unix
@@ -28,7 +29,7 @@
 TARGET  = freeimageplus
 STATICLIB = lib$(TARGET).a
 SHAREDLIB = lib$(TARGET)-$(VER_MAJOR).$(VER_MINOR).so
-LIBNAME	= lib$(TARGET).so
+LIBNAME	= lib$(TARGET).dylib
 VERLIBNAME = $(LIBNAME).$(VER_MAJOR)
 HEADER = Source/FreeImage.h
 HEADERFIP = Wrapper/FreeImagePlus/FreeImagePlus.h
@@ -40,7 +41,7 @@

 dist: FreeImage
	cp *.a Dist
-	cp *.so Dist
+	cp *.dylib Dist
	cp Source/FreeImage.h Dist
	cp Wrapper/FreeImagePlus/FreeImagePlus.h Dist

@@ -59,14 +60,15 @@
	$(AR) r $@ $(MODULES)
 
 $(SHAREDLIB): $(MODULES)
-	$(CC) -s -shared -Wl,-soname,$(VERLIBNAME) $(LDFLAGS) -o $@ $(MODULES) $(LIBRARIES)
+	$(CXX) -dynamiclib -install_name $(LIBNAME) -current_version $(VER_MAJOR).$(VER_MINOR) -compatibility_version $(VER_MAJOR) -o $@ $(MODULES)
 
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
