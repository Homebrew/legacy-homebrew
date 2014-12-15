require "formula"

class Groonga < Formula
  homepage "http://groonga.org/"
  url "http://packages.groonga.org/source/groonga/groonga-4.0.8.tar.gz"
  sha1 "894bf426c79aaab6e3b1f19811db4634aecdc4c2"

  bottle do
    revision 1
    sha1 "d4b6e1efd8b37b8f4e39918e154c687ba0735152" => :yosemite
    sha1 "5cc89ff268fe2ba9a9129dcb0f59c992a9e6cfaf" => :mavericks
    sha1 "4f8bcf386795fc42f40526663597fb53b8b19a66" => :mountain_lion
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

  # These patches are already merged into upstream.
  # Please remove next version of Groonga Formula.
  # pull #253 https://github.com/groonga/groonga/pull/253
  # fixed at: https://github.com/groonga/groonga/commit/c019cfbfbf5365c28ce727a46448aa6f77de8543
  # issue #254: https://github.com/groonga/groonga/issues/254
  # fixed at: https://github.com/groonga/groonga/commit/340085f132c640f03e32a7878f0bd31de9f74eaa
  # issue #256: https://github.com/groonga/groonga/issues/256
  # fixed at: https://github.com/groonga/groonga/commit/e2aa5217f0967457ae4f7edf799dbf8767400916
  # issue #264: https://github.com/groonga/groonga/issues/264
  # fixed at: https://github.com/groonga/groonga/commit/91207ecd816e873cdf7070ec7a1c5ae4870f7e6e
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

    # remove autoreconf when patches are removed
    system "autoreconf", "--force", "--install"

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
diff --git a/lib/grn.h b/lib/grn.h
index 868133c..b7f78e2 100644
--- a/lib/grn.h
+++ b/lib/grn.h
@@ -546,7 +546,7 @@ typedef int grn_cond;
 #  define GRN_MKOSTEMP(template,flags,mode) mkostemp(template,flags)
 # else /* HAVE_MKOSTEMP */
 #  define GRN_MKOSTEMP(template,flags,mode) \
-  (mktemp(template), GRN_OPEN((template),flags,mode))
+  (mktemp(template), GRN_OPEN((template),((flags)|O_RDWR|O_CREAT|O_EXCL),mode))
 # endif /* HAVE_MKOSTEMP */

 #elif (defined(WIN32) || defined (_WIN64)) /* __GNUC__ */
@@ -579,7 +579,7 @@ typedef int grn_cond;
 # define GRN_BIT_SCAN_REV0(v,r) GRN_BIT_SCAN_REV(v,r)

 # define GRN_MKOSTEMP(template,flags,mode) \
-  (mktemp(template), GRN_OPEN((template),((flags)|O_BINARY),mode))
+  (mktemp(template), GRN_OPEN((template),((flags)|O_RDWR|O_CREAT),mode))

 #else /* __GNUC__ */

diff --git a/lib/ii.c b/lib/ii.c
index 3e48bef..2ec4949 100644
--- a/lib/ii.c
+++ b/lib/ii.c
@@ -7428,13 +7428,10 @@ grn_ii_buffer_open(grn_ctx *ctx, grn_ii *ii,
       if (ii_buffer->counters) {
         ii_buffer->block_buf = GRN_MALLOCN(grn_id, II_BUFFER_BLOCK_SIZE);
         if (ii_buffer->block_buf) {
-          int open_flags = O_WRONLY|O_CREAT;
+          int open_flags = 0;
 #ifdef WIN32
           open_flags |= O_BINARY;
 #endif
-#ifdef BSD
-          open_flags &= O_APPEND|O_DIRECT|O_SHLOCK|O_EXLOCK|O_SYNC|O_CLOEXEC;
-#endif
           snprintf(ii_buffer->tmpfpath, PATH_MAX,
                    "%sXXXXXX", grn_io_path(ii->seg));
           ii_buffer->block_buf_size = II_BUFFER_BLOCK_SIZE;
