require 'formula'

class Gocr < Formula
  homepage 'http://jocr.sourceforge.net/'
  url 'http://www-e.uni-magdeburg.de/jschulen/ocr/gocr-0.50.tar.gz'
  sha1 '2018ddf7be1c95dcc12f63f7ac40ad98da06f8a4'

  bottle do
    cellar :any
    sha1 "f230e6056541648f1e0c0a869fbb4a5e1715822d" => :mavericks
    sha1 "2f07d5b621f299c7faaa992127fc106637a4e90c" => :mountain_lion
    sha1 "7137e18511cfd756baa7d19e81ce33cd5bdbf8c5" => :lion
  end

  option 'with-lib', 'Install library and headers'

  depends_on 'netpbm' => :optional

  # Edit makefile to install libs per developer documentation
  patch :DATA if build.with? "lib"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    # --mandir doesn't work correctly; fix broken Makefile
    inreplace "man/Makefile" do |s|
      s.change_make_var! 'mandir', '/share/man'
    end

    system "make libs" if build.with? "lib"
    system "make install"
  end

  test do
    system "#{bin}/gocr -h"
  end
end

__END__
diff --git a/src/Makefile.in b/src/Makefile.in
index bf4181f..883fec2
--- a/src/Makefile.in
+++ b/src/Makefile.in
@@ -10,7 +10,7 @@ PROGRAM = gocr$(EXEEXT)
 PGMASCLIB = Pgm2asc
 #LIBPGMASCLIB = lib$(PGMASCLIB).a
 # ToDo: need a better pgm2asc.h for lib users
-#INCLUDEFILES = gocr.h
+INCLUDEFILES = pgm2asc.h output.h list.h unicode.h gocr.h pnm.h
 # avoid german compiler messages
 LANG=C

@@ -39,8 +39,8 @@ LIBOBJS=pgm2asc.o \
 #VPATH = @srcdir@
 bindir = @bindir@
 #  lib removed for simplification
-#libdir = @libdir@
-#includedir = @includedir@
+libdir = @libdir@
+includedir = /include/gocr

 CC=@CC@
 # lib removed for simplification
@@ -89,7 +89,8 @@ $(PROGRAM): $(LIBOBJS) gocr.o
 	$(CC) -o $@ $(LDFLAGS) gocr.o $(LIBOBJS) $(LIBS)
 	# if test -r $(PROGRAM); then cp $@ ../bin; fi

-libs: lib$(PGMASCLIB).a lib$(PGMASCLIB).@PACKAGE_VERSION@.so
+#libs: lib$(PGMASCLIB).a lib$(PGMASCLIB).@PACKAGE_VERSION@.so
+libs: lib$(PGMASCLIB).a

 #lib$(PGMASCLIB).@PACKAGE_VERSION@.so: $(LIBOBJS)
 #	$(CC) -fPIC -shared -Wl,-h$@ -o $@ $(LIBOBJS)
@@ -109,17 +110,17 @@ $(LIBOBJS): Makefile
 # PHONY = don't look at file clean, -rm = start rm and ignore errors
 .PHONY : clean proper install uninstall
 install: all
-	#$(INSTALL) -d $(DESTDIR)$(bindir) $(DESTDIR)$(libdir) $(DESTDIR)$(includedir)
-	$(INSTALL) -d $(DESTDIR)$(bindir)
+	$(INSTALL) -d $(DESTDIR)$(bindir) $(DESTDIR)$(libdir) $(DESTDIR)$(includedir)
+	#$(INSTALL) -d $(DESTDIR)$(bindir)
 	$(INSTALL) $(PROGRAM) $(DESTDIR)$(bindir)
 	$(INSTALL) ../bin/gocr.tcl   $(DESTDIR)$(bindir)  # better X11/bin?
 	if test -f lib$(PGMASCLIB).a; then\
 	 $(INSTALL) lib$(PGMASCLIB).a $(DESTDIR)$(libdir);\
 	 $(INSTALL) lib$(PGMASCLIB).@PACKAGE_VERSION@.so $(DESTDIR)$(libdir);\
 	 $(INSTALL) lib$(PGMASCLIB).so $(DESTDIR)$(libdir);\
+	 $(INSTALL) $(INCLUDEFILES) $(DESTDIR)$(includedir);\
+	 $(INSTALL) ../include/config.h $(DESTDIR)$(includedir);\
 	fi
-	# ToDo: not sure that the link will be installed correctly
-	#$(INSTALL) $(INCLUDEFILES) $(DESTDIR)$(includedir)

 # directories are not removed
 uninstall:
@@ -129,7 +130,8 @@ uninstall:
 	-rm -f $(DESTDIR)$(libdir)/lib$(PGMASCLIB).@PACKAGE_VERSION@.so
 	-rm -f $(DESTDIR)$(libdir)/lib$(PGMASCLIB).so
 	# ToDo: set to old version.so ?
-	#for X in $(INCLUDEFILES); do rm -f $(DESTDIR)$(includedir)/$$X; done
+	for X in $(INCLUDEFILES); do rm -f $(DESTDIR)$(includedir)/$$X; done
+	-rm -f $(DESTDIR)$(includedir)/config.h

 clean:
 	-rm -f *.o *~
