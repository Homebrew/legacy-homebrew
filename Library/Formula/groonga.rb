require "formula"

class Groonga < Formula
  homepage "http://groonga.org/"
  url "http://packages.groonga.org/source/groonga/groonga-4.0.8.tar.gz"
  sha1 "894bf426c79aaab6e3b1f19811db4634aecdc4c2"

  bottle do
    sha1 "2775b6f11f9e37b2c217232a8c1330d96399f247" => :yosemite
    sha1 "666f42790d8c1971886af044f01d202158439597" => :mavericks
    sha1 "e98db97c283412714a64066c0250c33832f4472f" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "libtool" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pcre"
  depends_on "msgpack"
  depends_on "mecab" => :optional
  depends_on "mecab-ipadic" if build.with? "mecab"
  depends_on "lz4" => :optional
  depends_on "openssl"

  depends_on "glib" if build.include? "enable-benchmark"

  option "enable-benchmark", "Enable benchmark program for developer use"

  # Groonga issue #253, #254, #256
  # already fixed at master
  patch :DATA

  def install
    args = %W[
      --prefix=#{prefix}
      --with-zlib
      --disable-zeromq
      --with-mruby
      --without-libstemmer
    ]

    args << "--enable-benchmark" if build.include? "enable-benchmark"
    args << "--with-mecab" if build.with? "mecab"
    args << "--with-lz4" if build.with? "lz4"

    # autoreconf must be run, otherwise prebuilt configure may complain
    # about a version mismatch between included automake and Homebrew's
    system "autoreconf --force --install"
    # ZeroMQ is an optional dependency that will be auto-detected unless we disable it
    system "./configure", *args
    system "make install"
  end
end

__END__
diff --git a/lib/ii.c b/lib/ii.c
index 8f9f9a8..e82dc7f 100644
--- a/lib/ii.c
+++ b/lib/ii.c
@@ -37,6 +37,10 @@
 # include <oniguruma.h>
 #endif

+#ifndef O_DIRECT
+# define O_DIRECT 0
+#endif
+
 #define MAX_PSEG                 0x20000
 #define S_CHUNK                  (1 << GRN_II_W_CHUNK)
 #define W_SEGMENT                18
diff --git a/lib/grn.h b/lib/grn.h
index ab720ef..868133c 100644
--- a/lib/grn.h
+++ b/lib/grn.h
@@ -174,6 +174,10 @@ typedef SOCKET grn_sock;
 #  include <unistd.h>
 # endif /* HAVE_UNISTD_H */

+# ifndef __off64_t_defined
+typedef off_t off64_t;
+# endif
+
 # ifndef PATH_MAX
 #  if defined(MAXPATHLEN)
 #   define PATH_MAX MAXPATHLEN
diff --git a/vendor/onigmo/Makefile.am b/vendor/onigmo/Makefile.am
index 03083bd..9219783 100644
--- a/vendor/onigmo/Makefile.am
+++ b/vendor/onigmo/Makefile.am
@@ -7,7 +7,7 @@ CONFIGURE_DEPENDENCIES =			\
 ALL_DEPEND_TARGETS = onigmo-all
 CLEAN_DEPEND_TARGETS = onigmo-clean

-INSTALL_DEPEND_TARGETS =
+INSTALL_DEPEND_TARGETS = onigmo-all
 if WITH_SHARED_ONIGMO
 INSTALL_DEPEND_TARGETS += onigmo-install
 endif
