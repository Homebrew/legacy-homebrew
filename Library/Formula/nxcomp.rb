require 'formula'

class Nxcomp < Formula
  homepage 'http://wiki.x2go.org/doku.php/wiki:libs:nx-libs'
  url 'http://code.x2go.org/releases/source/nx-libs/nx-libs-3.5.0.24-lite.tar.gz'
  sha1 '0eea84b63dc0181fb4312aa41ee77168a1bdf7c9'
  version '3.5.0.24-lite'

  depends_on :autoconf
  depends_on :automake
  depends_on :x11
  depends_on :libpng
  depends_on 'jpeg'

  # Adapt for OSX
  def patches; DATA end

  def install
    # Build lib
    cd "nxcomp" do
      # Configure
      system "autoreconf", "--force", "--install"
      system "./configure", "--prefix=#{prefix}"

      # Actual build
      system "make", "install"
    end

    # Build binary
    cd "nxproxy" do
      # Link with lib
      ENV.append 'LDFLAGS', "-L#{lib}/nx"

      # Configure
      system "autoreconf", "--force", "--install"
      system "./configure", "--prefix=#{prefix}"

      # Actual build
      system "make", "install"
    end
  end
end

__END__
--- a/nxcomp/Makefile.in
+++ b/nxcomp/Makefile.in
@@ -91,9 +91,9 @@
 LIBRARY = Xcomp
 
 LIBNAME    = lib$(LIBRARY)
-LIBFULL    = lib$(LIBRARY).so.$(VERSION)
-LIBLOAD    = lib$(LIBRARY).so.$(LIBVERSION)
-LIBSHARED  = lib$(LIBRARY).so
+LIBFULL    = lib$(LIBRARY)$(VERSION).dylib
+LIBLOAD    = lib$(LIBRARY)$(LIBVERSION).dylib
+LIBSHARED  = lib$(LIBRARY).dylib
 LIBARCHIVE = lib$(LIBRARY).a
 
 LIBCYGSHARED  = cyg$(LIBRARY).dll
@@ -231,7 +231,11 @@
 CXXOBJ = $(CXXSRC:.cpp=.o)
 
 $(LIBFULL):	 $(CXXOBJ) $(COBJ)
-		 $(CXX) -o $@ $(LDFLAGS) $(CXXOBJ) $(COBJ) $(LIBS)
+		 $(CXX) -o $@ \
+			 -install_name $(libdir)/nx/$@ \
+			 -compatibility_version $(LIBVERSION) \
+			 -current_version $(LIBVERSION) \
+			 $(LDFLAGS) $(CXXOBJ) $(COBJ) $(LIBS)
 
 $(LIBLOAD):	 $(LIBFULL)
 		 rm -f $(LIBLOAD)
@@ -277,9 +281,9 @@
 	./mkinstalldirs $(DESTDIR)${libdir}/nx
 	./mkinstalldirs $(DESTDIR)${includedir}/nx
 	$(INSTALL_DATA) $(LIBFULL)              $(DESTDIR)${libdir}/nx
-	$(INSTALL_LINK) libXcomp.so.3           $(DESTDIR)${libdir}/nx
-	$(INSTALL_LINK) libXcomp.so             $(DESTDIR)${libdir}/nx
-	$(INSTALL_DATA) libXcomp.a              $(DESTDIR)${libdir}/nx
+	$(INSTALL_LINK) $(LIBLOAD)              $(DESTDIR)${libdir}/nx
+	$(INSTALL_LINK) $(LIBSHARED)            $(DESTDIR)${libdir}/nx
+	$(INSTALL_DATA) $(LIBARCHIVE)           $(DESTDIR)${libdir}/nx
 	$(INSTALL_DATA) NX*.h                   $(DESTDIR)${includedir}/nx
 	$(INSTALL_DATA) MD5.h                   $(DESTDIR)${includedir}/nx
 	echo "Running ldconfig tool, this may take a while..." && ldconfig || true
@@ -292,9 +296,9 @@
 
 uninstall.lib:
 	$(RM_FILE) $(DESTDIR)${libdir}/nx/$(LIBFULL)
-	$(RM_FILE) $(DESTDIR)${libdir}/nx/libXcomp.so.3
-	$(RM_FILE) $(DESTDIR)${libdir}/nx/libXcomp.so
-	$(RM_FILE) $(DESTDIR)${libdir}/nx/libXcomp.a
+	$(RM_FILE) $(DESTDIR)${libdir}/nx/$(LIBLOAD)
+	$(RM_FILE) $(DESTDIR)${libdir}/nx/$(LIBSHARED)
+	$(RM_FILE) $(DESTDIR)${libdir}/nx/$(LIBARCHIVE)
 	$(RM_FILE) $(DESTDIR)${includedir}/nx/NXalert.h
 	$(RM_FILE) $(DESTDIR)${includedir}/nx/NX.h
 	$(RM_FILE) $(DESTDIR)${includedir}/nx/NXmitshm.h
--- a/nxcomp/configure.in
+++ b/nxcomp/configure.in
@@ -187,7 +187,7 @@
 dnl the options -G -h.
 
 if test "$DARWIN" = yes; then
-  LDFLAGS="$LDFLAGS -bundle"
+  LDFLAGS="$LDFLAGS -dynamiclib"
 elif test "$SUN" = yes; then
   LDFLAGS="$LDFLAGS -G -h \$(LIBLOAD)"
 else
--- a/nxproxy/Makefile.in
+++ b/nxproxy/Makefile.in
@@ -15,11 +15,11 @@
            -Wall -Wpointer-arith -Wstrict-prototypes -Wmissing-prototypes \
            -Wmissing-declarations -Wnested-externs
 
-CXXINCLUDES = -I. -I../nxcomp
+CXXINCLUDES = -I. -I@prefix@/include/nx
 
 CC         = @CC@
 CCFLAGS    = $(CXXFLAGS)
-CCINCLUDES = -I. -I../nxcomp
+CCINCLUDES = -I. -I@prefix@/include/nx
 CCDEFINES  =
 
 LDFLAGS = @LDFLAGS@
--- a/nxproxy/configure.in
+++ b/nxproxy/configure.in
@@ -161,7 +161,7 @@
 if test "$CYGWIN32" = yes; then
     LIBS="$LIBS -L../nxcomp -lXcomp -lstdc++ -Wl,-e,_mainCRTStartup -ljpeg -lpng -lz"
 else
-    LIBS="$LIBS -L../nxcomp -lXcomp"
+    LIBS="$LIBS -lXcomp"
 fi
 
 dnl Find makedepend somewhere.
Description: In Types.h, don't use STL internals on libc++.
Author: Clemens Lang <cal@macports.org>
Abstract:
 The nx-libs-lite package does not compile on OS X Mavericks because
 Apple's clang compilers now default to compiling against the libc++ STL
 rather than (their outdated copy of) libstdc++.
 .
 While the compiler still allows changing that, we should not rely on
 this being possible forever.
 .
 The compiler chokes in Types.h, specifically the clear() methods in
 subclasses of vectors that use implementation details of the GNU STL.
 The attached patch fixes these compilation issues by not overriding the
 clear() method when compiling against libc++, since the libc++ headers
 seem to do essentially the same as the overriden method.
--- a/nxcomp/Types.h	2013-11-05 01:35:22.000000000 +0100
+++ b/nxcomp/Types.h	2013-11-05 01:37:30.000000000 +0100
@@ -55,6 +55,9 @@
     return &*(vector < unsigned char >::begin());
   }
 
+  // Avoid overriding clear() when using libc++. Fiddling with STL internals
+  // doesn't really seem like a good idea to me anyway.
+  #ifndef _LIBCPP_VECTOR
   void clear()
   {
     #if defined(__STL_USE_STD_ALLOCATORS) || defined(__GLIBCPP_INTERNAL_VECTOR_H)
@@ -95,12 +98,16 @@
 
     #endif  /* #if defined(__STL_USE_STD_ALLOCATORS) || defined(__GLIBCPP_INTERNAL_VECTOR_H) */
   }
+  #endif /* #ifdef _LIBCPP_VECTOR */
 };
 
 class T_messages : public vector < Message * >
 {
   public:
 
+  // Avoid overriding clear() when using libc++. Fiddling with STL internals
+  // doesn't really seem like a good idea to me anyway.
+  #ifndef _LIBCPP_VECTOR
   void clear()
   {
     #if defined(__STL_USE_STD_ALLOCATORS) || defined(__GLIBCPP_INTERNAL_VECTOR_H)
@@ -141,6 +148,7 @@
 
     #endif /* #if defined(__STL_USE_STD_ALLOCATORS) || defined(__GLIBCPP_INTERNAL_VECTOR_H) */
   }
+  #endif /* #ifndef _LIBCPP_VECTOR */
 };
 
 typedef md5_byte_t * T_checksum;
