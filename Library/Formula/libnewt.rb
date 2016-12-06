require 'formula'

class Libnewt < Formula
  url 'https://fedorahosted.org/releases/n/e/newt/newt-0.52.12.tar.gz'
  homepage 'https://fedorahosted.org/newt/'
  md5 '51b04128d9e1bf000fa769c417b74486'

  depends_on 'slang'
  depends_on 'popt'

  def patches
    # Patches to make it compile on OS X
    DATA
  end

  def install
    system "./configure", "--disable-nls", "--without-tcl", "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
diff --git i/Makefile.in w/Makefile.in
index f64ffe3..0cd1e5e 100644
--- i/Makefile.in
+++ w/Makefile.in
@@ -6,12 +6,11 @@ CPP = @CPP@
 CFLAGS = @CFLAGS@
 CPPFLAGS = -D_GNU_SOURCE -I/usr/include/slang @CPPFLAGS@ 

-SHLIBFLAGS= -Wl,--version-script,newt.0.52.ver
+SHLIBFLAGS= -Wl
 VERSION = @VERSION@
 TAG = r$(subst .,-,$(VERSION))
 SONAME = @SONAME@

-PYTHONVERS = @PYTHONVERS@
 WHIPTCLSO = @WHIPTCLSO@

 PROGS = test whiptail $(WHIPTCLSO) testgrid testtree showchars showkey
@@ -50,7 +49,7 @@ else
 TARGET=depend $(PROGS)
 endif

-all:	$(TARGET) _snackmodule.so
+all:	$(TARGET)

 test:	test.o $(LIBNEWT)
 	$(CC) -g -o test test.o $(LIBNEWT) $(LIBS)
@@ -67,14 +66,6 @@ showchars:	showchars.o $(LIBNEWT)
 showkey:	showkey.o $(LIBNEWT)
 	$(CC) -g -o showkey showkey.o $(LIBNEWT) $(LIBS)

-_snackmodule.so:   snackmodule.c $(LIBNEWTSH)
-	for ver in $(PYTHONVERS) ; do \
-	    	mkdir -p $$ver ;\
-	        $(CC) $(CFLAGS) -I/usr/include/$$ver $(SHCFLAGS) -c -o $$ver/snackmodule.o snackmodule.c ;\
-		$(CC) --shared $(SHCFLAGS) -o $$ver/_snackmodule.so $$ver/snackmodule.o -L .  -lnewt ;\
-	done
-	touch $@
-
 whiptail: $(NDIALOGOBJS) $(LIBNEWTSH)
 	$(CC) -g -o whiptail $(NDIALOGOBJS) -L . -lnewt $(LIBS) -lpopt

@@ -102,7 +93,7 @@ $(SHAREDDIR):
 sharedlib: $(LIBNEWTSH)

 $(LIBNEWTSH): $(SHAREDDIR) $(SHAREDOBJS)
-	$(CC) -shared -o $(LIBNEWTSH) $(SHLIBFLAGS) -Wl,-soname,$(LIBNEWTSONAME) $(SHAREDOBJS) $(LIBS)
+	$(CC) -shared -o $(LIBNEWTSH) $(SHLIBFLAGS) -Wl,-dylib_install_name,$(LIBNEWTSONAME) $(SHAREDOBJS) $(LIBS)
 	ln -fs $(LIBNEWTSONAME) libnewt.so
 	ln -fs $(LIBNEWTSH) $(LIBNEWTSONAME)

@@ -121,17 +112,12 @@ install: $(LIBNEWT) install-sh whiptail
 	make -C po datadir=$(instroot)/$(datadir) install
 	install -m 644 -D libnewt.pc $(instroot)/$(pkgconfigdir)/libnewt.pc

-install-sh: sharedlib $(WHIPTCLSO) _snackmodule.so
+install-sh: sharedlib $(WHIPTCLSO)
 	[ -d $(instroot)/$(libdir) ] || install -m 755 -d $(instroot)/$(libdir)
 	install -m 755 $(LIBNEWTSH) $(instroot)/$(libdir)
 	ln -sf $(LIBNEWTSONAME) $(instroot)/$(libdir)/libnewt.so
 	ln -sf $(LIBNEWTSH) $(instroot)/$(libdir)/$(LIBNEWTSONAME)
 	[ -n "$(WHIPTCLSO)" ] && install -m 755 whiptcl.so $(instroot)/$(libdir) || :
-	for ver in $(PYTHONVERS) ; do \
-	   [ -d $(instroot)/$(libdir)/$$ver/site-packages ] || install -m 755 -d $(instroot)/$(libdir)/$$ver/site-packages ;\
-	   install -m 755 $$ver/_snackmodule.so $(instroot)/$(libdir)/$$ver/site-packages ;\
-	   install -m 644 snack.py $(instroot)/$(libdir)/$$ver/site-packages ;\
-	done

 Makefile: newt.spec
 	echo "You need to rerun ./configure before continuing"
diff --git i/whiptail.c w/whiptail.c
index 09eca15..a0da6e1 100644
--- i/whiptail.c
+++ w/whiptail.c
@@ -8,6 +8,7 @@
 #include <unistd.h>
 #include <wchar.h>
 #include <slang.h>
+#include <sys/stat.h>

 #include "nls.h"
 #include "dialogboxes.h"
diff --git i/Makefile.in w/Makefile.in
index 0cd1e5e..ca8ecd6 100644
--- i/Makefile.in
+++ w/Makefile.in
@@ -110,7 +110,8 @@ install: $(LIBNEWT) install-sh whiptail
 	install -m 755 whiptail $(instroot)/$(bindir)
 	install -m 644 whiptail.1 $(instroot)/$(man1dir)
 	make -C po datadir=$(instroot)/$(datadir) install
-	install -m 644 -D libnewt.pc $(instroot)/$(pkgconfigdir)/libnewt.pc
+	install -m 755 -d $(instroot)/$(pkgconfigdir)
+	install -m 644 libnewt.pc $(instroot)/$(pkgconfigdir)/libnewt.pc

 install-sh: sharedlib $(WHIPTCLSO)
 	[ -d $(instroot)/$(libdir) ] || install -m 755 -d $(instroot)/$(libdir)
