require 'formula'

class Libtommath < Formula
  url 'http://libtom.org/files/ltm-0.42.0.tar.bz2'
  homepage 'http://libtom.org/?page=features&newsitems=5&whatfile=ltm'
  md5 '7380da904b020301be7045cb3a89039b'

  def patches
    DATA # Makefile tries to install as root:wheel
  end

  def install
    ENV['DESTDIR'] = prefix
    system "make install"
  end
end

__END__
diff --git a/makefile b/makefile
index 70de306..989e1b7 100755
--- a/makefile
+++ b/makefile
@@ -27,19 +27,6 @@ CFLAGS  += -fomit-frame-pointer

 endif

-#install as this user
-ifndef INSTALL_GROUP
-   GROUP=wheel
-else
-   GROUP=$(INSTALL_GROUP)
-endif
-
-ifndef INSTALL_USER
-   USER=root
-else
-   USER=$(INSTALL_USER)
-endif
-
 #default files to install
 ifndef LIBNAME
    LIBNAME=libtommath.a
@@ -52,10 +39,13 @@ HEADERS=tommath.h tommath_class.h tommath_superclass.h
 #LIBPATH-The directory for libtommath to be installed to.
 #INCPATH-The directory to install the header files for libtommath.
 #DATAPATH-The directory to install the pdf docs.
+ifndef DESTDIR
 DESTDIR=
-LIBPATH=/usr/lib
-INCPATH=/usr/include
-DATAPATH=/usr/share/doc/libtommath/pdf
+endif
+
+LIBPATH=/lib
+INCPATH=/include
+DATAPATH=/share/doc/libtommath/pdf

 OBJECTS=bncore.o bn_mp_init.o bn_mp_clear.o bn_mp_exch.o bn_mp_grow.o bn_mp_shrink.o \
 bn_mp_clamp.o bn_mp_zero.o  bn_mp_set.o bn_mp_set_int.o bn_mp_init_size.o bn_mp_copy.o \
@@ -113,10 +103,10 @@ profiled_single:
        ranlib $(LIBNAME)

 install: $(LIBNAME)
-	install -d -g $(GROUP) -o $(USER) $(DESTDIR)$(LIBPATH)
-	install -d -g $(GROUP) -o $(USER) $(DESTDIR)$(INCPATH)
-	install -g $(GROUP) -o $(USER) $(LIBNAME) $(DESTDIR)$(LIBPATH)
-	install -g $(GROUP) -o $(USER) $(HEADERS) $(DESTDIR)$(INCPATH)
+	install -d $(DESTDIR)$(LIBPATH)
+	install -d $(DESTDIR)$(INCPATH)
+	install $(LIBNAME) $(DESTDIR)$(LIBPATH)
+	install $(HEADERS) $(DESTDIR)$(INCPATH)

 test: $(LIBNAME) demo/demo.o
        $(CC) $(CFLAGS) demo/demo.o $(LIBNAME) -o test
