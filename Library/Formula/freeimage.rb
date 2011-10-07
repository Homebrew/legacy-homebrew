require 'formula'

class FreeimageHttpDownloadStrategy <CurlDownloadStrategy
  def stage
    # need to convert newlines or patch chokes
    safe_system '/usr/bin/unzip', '-aqq', @tarball_path
    chdir
  end
end

class Freeimage < Formula
  url 'http://downloads.sourceforge.net/project/freeimage/Source%20Distribution/3.13.1/FreeImage3131.zip',
        :using => FreeimageHttpDownloadStrategy
  version '3.13.1'
  md5 'a2e20b223a2cf6a5791cc47686364e99'
  homepage 'http://sf.net/projects/freeimage'

  def patches
    DATA
  end

  def install
    system "gnumake -f Makefile.gnu"
    system "gnumake -f Makefile.gnu install PREFIX=#{prefix}"
  end
end

__END__
--- old/Makefile.gnu	2009-07-27 20:35:26.000000000 -0400
+++ new/Makefile.gnu	2009-11-16 10:53:33.000000000 -0300
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
@@ -55,16 +55,17 @@
 	$(CXX) $(CXXFLAGS) -c $< -o $@
 
 $(STATICLIB): $(MODULES)
-	$(AR) r $@ $(MODULES)
+	$(LIBTOOL) -static -o $@ $(MODULES)
 
 $(SHAREDLIB): $(MODULES)
-	$(CC) -shared -Wl,-soname,$(VERLIBNAME) $(LDFLAGS) -o $@ $(MODULES) $(LIBRARIES)
+	$(CXX) -dynamiclib -install_name $(LIBNAME) -current_version $(VER_MAJOR).$(VER_MINOR) -compatibility_version $(VER_MAJOR) -o $@ $(MODULES)
 
 install:
 	install -d $(INCDIR) $(INSTALLDIR)
-	install -m 644 -o root -g root $(HEADER) $(INCDIR)
-	install -m 644 -o root -g root $(STATICLIB) $(INSTALLDIR)
-	install -m 755 -o root -g root $(SHAREDLIB) $(INSTALLDIR)
+	install -m 644 $(HEADER) $(INCDIR)
+	install -m 644 $(STATICLIB) $(INSTALLDIR)
+	install -m 755 $(SHAREDLIB) $(INSTALLDIR)
+	ln -s $(SHAREDLIB) $(INSTALLDIR)/$(LIBNAME)
 
 clean:
 	rm -f core Dist/*.* u2dtmp* $(MODULES) $(STATICLIB) $(SHAREDLIB) $(LIBNAME)
