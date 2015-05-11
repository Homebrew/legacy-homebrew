class Rhash < Formula
  homepage "http://rhash.anz.ru/"
  url "https://downloads.sourceforge.net/project/rhash/rhash/1.3.3/rhash-1.3.3-src.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/r/rhash/rhash_1.3.3.orig.tar.gz"
  sha256 "5b520b597bd83f933d316fce1382bb90e0b0b87b559b8c9c9a197551c935315a"

  head "https://github.com/rhash/RHash.git"

  bottle do
    cellar :any
    sha1 "cb5c136e11633ffb2bb28248e61ef468a724a6a5" => :mavericks
    sha1 "25acb04254d9b202a7a016e89b28898fed48d65a" => :mountain_lion
    sha1 "0ea791f790338589aea739b56948b126e5e75f1d" => :lion
  end

  # Upstream issue: https://github.com/rhash/RHash/pull/7
  # This patch will need to be in place permanently.
  patch :DATA

  def install
    # install target isn't parallel-safe
    ENV.j1

    system "make", "lib-static", "lib-shared", "all", "CC=#{ENV.cc}"
    system "make", "install-lib-static", "install-lib-shared", "install",
                   "PREFIX=", "DESTDIR=#{prefix}", "CC=#{ENV.cc}"
  end

  test do
    (testpath/"test").write("test")
    (testpath/"test.sha1").write("a94a8fe5ccb19ba61c4c0873d391e987982fbbd3 test")
    system "#{bin}/rhash", "-c", "test.sha1"
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
-	sed -n '1s/.*/{ global:/p; s/^RHASH_API.* \([a-z0-9_]\+\)(.*/  \1;/p; $$s/.*/local: *; };/p' $(SO_HEADERS) > exports.sym
-	$(CC) -fpic $(ALLCFLAGS) -shared $(SOURCES) -Wl,--version-script,exports.sym,-soname,$(SONAME) $(LIBLDFLAGS) -o $@
+	$(CC) -fpic $(ALLCFLAGS) -dynamiclib $(SOURCES) $(LIBLDFLAGS) -Wl,-install_name,$(PREFIX)/lib/$@ -o $@
 	ln -s $(SONAME) $(SOLINK)
 # use 'nm -Cg --defined-only $@' to view exported symbols
