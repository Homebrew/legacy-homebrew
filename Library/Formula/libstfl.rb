require 'formula'

class Libstfl < Formula
  homepage 'http://www.clifford.at/stfl/'
  url 'http://www.clifford.at/stfl/stfl-0.22.tar.gz'
  sha1 '226488be2b33867dfb233f0fa2dde2d066e494bd'

  def patches; DATA; end

  def install
    system "make", "install",
                   "CC=#{ENV.cc} -pthread",
                   "prefix=#{prefix}"
  end
end

__END__
---
 Makefile                | 31 ++++++++++++++++++++-----------
 perl5/Makefile.PL       |  2 +-
 python/Makefile.snippet |  8 ++++++--
 ruby/Makefile.snippet   |  2 +-
 stfl.pc.in              |  2 +-
 stfl_internals.h        |  2 +-
 6 files changed, 30 insertions(+), 17 deletions(-)

diff --git a/Makefile b/Makefile
index d481e68..99fbe56 100644
--- a/Makefile
+++ b/Makefile
@@ -22,12 +22,17 @@ include Makefile.cfg
 
 export CC = gcc -pthread
 export CFLAGS += -I. -Wall -Os -ggdb -D_GNU_SOURCE -fPIC
-export LDLIBS += -lncursesw
+export LDLIBS += -lncurses
 
 SONAME  := libstfl.so.0
 VERSION := 0.22
 
-all: libstfl.so.$(VERSION) libstfl.a example
+export LDLIBS += $(LD_FLAGS) -liconv
+SONAME  := libstfl.dylib
+SONAME0 := libstfl.0.dylib
+SONAMEV := libstfl.$(VERSION).dylib
+
+all: $(SONAMEV) libstfl.a example
 
 example: libstfl.a example.o
 
@@ -37,20 +42,20 @@ libstfl.a: public.o base.o parser.o dump.o style.o binding.o iconv.o \
 	ar qc $@ $^
 	ranlib $@
 
-libstfl.so.$(VERSION): public.o base.o parser.o dump.o style.o binding.o iconv.o \
+$(SONAMEV): public.o base.o parser.o dump.o style.o binding.o iconv.o \
                        $(patsubst %.c,%.o,$(wildcard widgets/*.c))
-	$(CC) -shared -Wl,-soname,$(SONAME) -o $@ $(LDLIBS) $^
+	$(CC) -shared -Wl -o $@ $(LDLIBS) $^
 
 clean:
 	rm -f libstfl.a example core core.* *.o Makefile.deps
 	rm -f widgets/*.o spl/mod_stfl.so spl/example.db
 	cd perl5 && perl Makefile.PL && make clean && rm -f Makefile.old
 	rm -f perl5/stfl_wrap.c perl5/stfl.pm perl5/build_ok
-	rm -f python/stfl.py python/stfl.pyc python/_stfl.so 
+	rm -f python/stfl.py python/stfl.pyc python/_stfl.so
 	rm -f python/stfl_wrap.c python/stfl_wrap.o
 	rm -f ruby/Makefile ruby/stfl_wrap.c ruby/stfl_wrap.o
 	rm -f ruby/stfl.so ruby/build_ok Makefile.deps_new
-	rm -f stfl.pc libstfl.so libstfl.so.*
+	rm -f stfl.pc $(SONAME) $(SONAME0) $(SONAMEV)
 
 Makefile.deps: *.c widgets/*.c *.h
 	$(CC) -I. -MM *.c > Makefile.deps_new
@@ -63,8 +68,8 @@ install: all stfl.pc
 	install -m 644 libstfl.a $(DESTDIR)$(prefix)/$(libdir)
 	install -m 644 stfl.h $(DESTDIR)$(prefix)/include/
 	install -m 644 stfl.pc $(DESTDIR)$(prefix)/$(libdir)/pkgconfig/
-	install -m 644 libstfl.so.$(VERSION) $(DESTDIR)$(prefix)/$(libdir)
-	ln -fs libstfl.so.$(VERSION) $(DESTDIR)$(prefix)/$(libdir)/libstfl.so
+	install -m 644 $(SONAMEV) $(DESTDIR)$(prefix)/$(libdir)
+	ln -fs $(SONAMEV) $(DESTDIR)$(prefix)/$(libdir)/$(SONAME)
 
 stfl.pc: stfl.pc.in
 	sed 's,@VERSION@,$(VERSION),g' < $< | sed 's,@PREFIX@,$(prefix),g' > $@
@@ -73,9 +78,13 @@ ifeq ($(FOUND_SPL),1)
 include spl/Makefile.snippet
 endif
 
-ifeq ($(FOUND_SWIG)$(FOUND_PERL5),11)
-include perl5/Makefile.snippet
-endif
+# OS X 10.7 note - commented out Perl since ExtUtils::MakeMaker configures
+# and attempts install to /Network:
+#   installvendorarch='/Network/Library/Perl/5.12/darwin-thread-multi-2level';
+#
+#ifeq ($(FOUND_SWIG)$(FOUND_PERL5),11)
+#include perl5/Makefile.snippet
+#endif
 
 ifeq ($(FOUND_SWIG)$(FOUND_PYTHON),11)
 include python/Makefile.snippet
diff --git a/perl5/Makefile.PL b/perl5/Makefile.PL
index 1c4fa58..501ff7d 100644
--- a/perl5/Makefile.PL
+++ b/perl5/Makefile.PL
@@ -3,6 +3,6 @@ WriteMakefile(
         "NAME"      => "stfl",
 	# The -D_LARGEFILE64_SOURCE -D_GNU_SOURCE are needed by perl (not STFL!) on some systems
 	"CCFLAGS"   => "-pthread -I.. -D_LARGEFILE64_SOURCE -D_GNU_SOURCE",
-        "LIBS"      => ["-lpthread -lncursesw"],
+        "LIBS"      => ["-lpthread -lncurses"],
         "OBJECT"    => "stfl_wrap.o ../libstfl.a"
 );
diff --git a/python/Makefile.snippet b/python/Makefile.snippet
index 8fd4052..0eb3f16 100644
--- a/python/Makefile.snippet
+++ b/python/Makefile.snippet
@@ -27,8 +27,12 @@ install: install_python
 
 python/_stfl.so python/stfl.py python/stfl.pyc: libstfl.a stfl.h python/stfl.i swig/*.i
 	cd python && swig -python -threads stfl.i
-	gcc -shared -pthread -fPIC python/stfl_wrap.c -I/usr/include/python$(PYTHON_VERSION) \
-		-I. libstfl.a -lncursesw -o python/_stfl.so
+	$(CC) -shared -pthread -fPIC python/stfl_wrap.c \
+		-L$(shell python-config --prefix)/lib \
+		$(shell python-config --include) \
+		$(shell python-config --ldflags) \
+		-liconv \
+		-I. libstfl.a -lncurses -o python/_stfl.so
 	cd python && python -c 'import stfl'
 
 install_python: python/_stfl.so python/stfl.py python/stfl.pyc
diff --git a/ruby/Makefile.snippet b/ruby/Makefile.snippet
index e0cf641..c837563 100644
--- a/ruby/Makefile.snippet
+++ b/ruby/Makefile.snippet
@@ -25,7 +25,7 @@ install: install_ruby
 
 ruby/build_ok: libstfl.a stfl.h ruby/stfl.i swig/*.i
 	cd ruby && swig -ruby stfl.i && ruby extconf.rb
-	$(MAKE) -C ruby clean && $(MAKE) -C ruby LIBS+="../libstfl.a -lncursesw" CFLAGS+="-pthread -I.." DLDFLAGS+="-pthread" DESTDIR=$(DESTDIR) prefix=$(prefix) sitedir=$(prefix)/$(libdir)/ruby
+	$(MAKE) -C ruby clean && $(MAKE) -C ruby LIBS+="../libstfl.a -lncurses -lruby -liconv" CFLAGS+="-pthread -I.." DLDFLAGS+="-pthread" DESTDIR=$(DESTDIR) prefix=$(prefix) sitedir=$(prefix)/$(libdir)/ruby
 	touch ruby/build_ok
 
 install_ruby: ruby/build_ok
diff --git a/stfl.pc.in b/stfl.pc.in
index 0e4cd84..4d9cca8 100644
--- a/stfl.pc.in
+++ b/stfl.pc.in
@@ -9,5 +9,5 @@ Name: STFL
 Description: Structured Terminal Forms Language/Library
 Version: @VERSION@
 Libs: -L${libdir} -lstfl
-Libs.private: -lncursesw
+Libs.private: -lncurses
 Cflags: -I${includedir}
diff --git a/stfl_internals.h b/stfl_internals.h
index 3f9f45b..1559626 100644
--- a/stfl_internals.h
+++ b/stfl_internals.h
@@ -28,7 +28,7 @@ extern "C" {
 #endif
 
 #include "stfl.h"
-#include <ncursesw/ncurses.h>
+#include <ncurses.h>
 #include <pthread.h>
 
 struct stfl_widget_type;
-- 
1.7.11.1

