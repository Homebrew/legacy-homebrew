require 'formula'

class Rhash < Formula
  homepage 'http://rhash.anz.ru/'
  url 'https://downloads.sourceforge.net/project/rhash/rhash/1.3.1/rhash-1.3.1-src.tar.gz'
  sha1 '3ecba2786909cc0d8bff253d94b0f313cbf2a6b1'

  # Upstream issue: https://github.com/rhash/RHash/pull/7
  patch :DATA

  def install
    # install target isn't parallel-safe
    ENV.j1

    system "make", "lib-static", "lib-shared", "all", "CC=#{ENV.cc}"

    system "make", "install-lib-static", "install-lib-shared", "install", "PREFIX=",
                              "DESTDIR=#{prefix}", "CC=#{ENV.cc}"
  end
end

__END__
--- a/librhash/Makefile	2014-04-20 14:20:22.000000000 +0200
+++ b/librhash/Makefile	2014-04-20 14:40:02.000000000 +0200
@@ -26,8 +26,8 @@
 INCDIR  = $(PREFIX)/include
 LIBDIR  = $(PREFIX)/lib
 LIBRARY = librhash.a
-SONAME  = librhash.so.0
-SOLINK  = librhash.so
+SONAME  = librhash.0.dylib
+SOLINK  = librhash.dylib
 TEST_TARGET = test_hashes
 TEST_SHARED = test_shared
 # Set variables according to GNU coding standard
@@ -176,8 +176,7 @@

 # shared and static libraries
 $(SONAME): $(SOURCES)
-	sed -n '1s/.*/{ global:/p; s/^RHASH_API.* \([a-z0-9_]\+\)(.*/  \1;/p; $$s/.*/local: *; };/p' $(LIB_HEADERS) > exports.sym
-	$(CC) -fpic $(ALLCFLAGS) -shared $(SOURCES) -Wl,--version-script,exports.sym,-soname,$(SONAME) $(LIBLDFLAGS) -o $@
+	$(CC) -fpic $(ALLCFLAGS) -dynamiclib $(SOURCES) $(LIBLDFLAGS) -Wl,-install_name,$(PREFIX)/lib/$@ -o $@
 	ln -s $(SONAME) $(SOLINK)
 # use 'nm -Cg --defined-only $@' to view exported symbols
