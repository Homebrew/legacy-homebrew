require 'formula'

class Graphviz < Formula
  url 'http://www.graphviz.org/pub/graphviz/stable/SOURCES/graphviz-2.28.0.tar.gz'
  md5 '8d26c1171f30ca3b1dc1b429f7937e58'
  homepage 'http://graphviz.org/'

  depends_on 'pkg-config' => :build

  if ARGV.include? '--with-pdf'
    depends_on 'pango'
    depends_on 'cairo' if MacOS.leopard? or MacOS.lion?
    depends_on 'gd' if MacOS.lion?
  end

  def options
    [["--with-pdf", "Build with Pango/Cairo to support native PDF output"]]
  end

  def patches
    # fix build on platforms without /usr/lib/libltdl.a (i.e., Lion)
    # http://www.graphviz.org/mantisbt/view.php?id=2109
    # fixed in upstream development version 2.29
    DATA if MacOS.lion?
  end

  def install
    ENV.x11
    # Various language bindings fail with 32/64 issues.
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-qt=no",
                          "--disable-quartz",
                          "--disable-java",
                          "--disable-ocaml",
                          "--disable-perl",
                          "--disable-php",
                          "--disable-python",
                          "--disable-r",
                          "--disable-ruby",
                          "--disable-sharp",
                          "--disable-swig"
    system "make install"
  end

  def test
    mktemp do
      p = Pathname.new Dir.pwd
      (p+'sample.dot').write <<-EOS.undent
      digraph G {
        a -> b
      }
      EOS

      system "#{bin}/dot -Tpdf -o sample.pdf sample.dot && /usr/bin/open ./sample.pdf && /bin/sleep 3"
    end
  end
end

__END__
diff --git a/lib/gvc/Makefile.in b/lib/gvc/Makefile.in
index 2d345a0..67183f2 100644
--- a/lib/gvc/Makefile.in
+++ b/lib/gvc/Makefile.in
@@ -41,8 +41,7 @@ host_triplet = @host@
 @WITH_WIN32_TRUE@am__append_1 = -O0
 @WITH_ORTHO_TRUE@am__append_2 = $(top_builddir)/lib/ortho/libortho_C.la
 @WITH_ORTHO_TRUE@am__append_3 = $(top_builddir)/lib/ortho/libortho_C.la
-@ENABLE_LTDL_TRUE@am__append_4 = $(LIBLTDL) $(LIBLTDL_LDFLAGS)
-@ENABLE_LTDL_TRUE@am__append_5 = $(LIBLTDL)
+@ENABLE_LTDL_TRUE@am__append_4 = @LIBLTDL@ $(LIBLTDL_LDFLAGS)
 subdir = lib/gvc
 DIST_COMMON = $(noinst_HEADERS) $(pkginclude_HEADERS) \
 	$(srcdir)/Makefile.am $(srcdir)/Makefile.in \
@@ -87,8 +86,7 @@ am__installdirs = "$(DESTDIR)$(libdir)" "$(DESTDIR)$(man3dir)" \
 	"$(DESTDIR)$(pkgincludedir)"
 LTLIBRARIES = $(lib_LTLIBRARIES) $(noinst_LTLIBRARIES)
 am__DEPENDENCIES_1 =
-@ENABLE_LTDL_TRUE@am__DEPENDENCIES_2 = $(am__DEPENDENCIES_1) \
-@ENABLE_LTDL_TRUE@	$(am__DEPENDENCIES_1)
+@ENABLE_LTDL_TRUE@am__DEPENDENCIES_2 = $(am__DEPENDENCIES_1)
 am__DEPENDENCIES_3 = $(top_builddir)/lib/pack/libpack_C.la \
 	$(top_builddir)/lib/xdot/libxdot_C.la \
 	$(top_builddir)/lib/common/libcommon_C.la $(am__append_2) \
