require 'formula'

class Stfl <Formula
  url 'http://www.clifford.at/stfl/stfl-0.21.tar.gz'
  homepage 'http://www.clifford.at/stfl/'
  md5 '888502c3f332a0ee66e490690d79d404'

  depends_on 'ncursesw'
  depends_on 'libiconv'

  def patches
    DATA
  end

  def install
    system "make FOUND_SWIG=0"
    system "make FOUND_SWIG=0 install prefix=#{prefix}"
  end
end
__END__
diff --git a/Makefile b/Makefile
index eb976b5..97c4d79 100644
--- a/Makefile
+++ b/Makefile
@@ -22,12 +22,12 @@ include Makefile.cfg
 
 export CC = gcc -pthread
 export CFLAGS += -I. -Wall -Os -ggdb -D_GNU_SOURCE -fPIC
-export LDLIBS += -lncursesw
+export LDLIBS += $(LDFLAGS) -lncursesw -liconv
 
 SONAME  := libstfl.so.0
 VERSION := 0.21
 
-all: libstfl.so.$(VERSION) libstfl.a example
+all: libstfl.$(VERSION).dylib libstfl.a example
 
 example: libstfl.a example.o
 
@@ -37,9 +37,9 @@ libstfl.a: public.o base.o parser.o dump.o style.o binding.o iconv.o \
 	ar qc $@ $^
 	ranlib $@
 
-libstfl.so.$(VERSION): public.o base.o parser.o dump.o style.o binding.o iconv.o \
+libstfl.$(VERSION).dylib: public.o base.o parser.o dump.o style.o binding.o iconv.o \
                        $(patsubst %.c,%.o,$(wildcard widgets/*.c))
-	$(CC) -shared -Wl,-soname,$(SONAME) -o $@ $^
+	$(CC) -shared -o $@ $^ $(LDLIBS)
 
 clean:
 	rm -f libstfl.a example core core.* *.o Makefile.deps
@@ -63,8 +63,8 @@ install: all stfl.pc
 	install -m 644 libstfl.a $(DESTDIR)$(prefix)/$(libdir)
 	install -m 644 stfl.h $(DESTDIR)$(prefix)/include/
 	install -m 644 stfl.pc $(DESTDIR)$(prefix)/$(libdir)/pkgconfig/
-	install -m 644 libstfl.so.$(VERSION) $(DESTDIR)$(prefix)/$(libdir)
-	ln -fs libstfl.so.$(VERSION) $(DESTDIR)$(prefix)/$(libdir)/libstfl.so
+	install -m 644 libstfl.$(VERSION).dylib $(DESTDIR)$(prefix)/$(libdir)
+	ln -fs libstfl.$(VERSION).dylib $(DESTDIR)$(prefix)/$(libdir)/libstfl.dylib
 
 stfl.pc: stfl.pc.in
 	sed 's,@VERSION@,$(VERSION),g' < $< | sed 's,@PREFIX@,$(prefix),g' > $@
