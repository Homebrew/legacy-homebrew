require 'formula'

def build_bindings?
  ARGV.include? '--with-bindings' and not ARGV.include? '--without-bindings'
end

class Graphviz < Formula
  homepage 'http://graphviz.org/'
  url 'http://www.graphviz.org/pub/graphviz/stable/SOURCES/graphviz-2.28.0.tar.gz'
  sha1 '4725d88a13e071ee22e632de551d4a55ca08ee7d'

  option :universal

  depends_on :libpng

  depends_on 'pkg-config' => :build
  depends_on 'pango' if ARGV.include? '--with-pangocairo'
  depends_on 'swig' if build_bindings?

  fails_with :clang do
    build 318
  end

  def options
    [
      ["--with-pangocairo", "Build with Pango/Cairo for alternate PDF output"],
      ["--with[out]-bindings", "Build Perl/Python/Ruby/etc. bindings (default on Lion; may not work on earlier systems)"]
    ]
  end

  def patches
    { :p0 => "https://trac.macports.org/export/78507/trunk/dports/graphics/graphviz-gui/files/patch-project.pbxproj.diff",
    :p1 => DATA}
  end

  def install
    ENV.universal_binary if build.universal?
    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--with-qt=no",
            "--without-x",
            "--with-quartz"]
    args << "--disable-swig" unless build_bindings?
    args << "--without-pangocairo" unless ARGV.include? '--with-pangocairo'

    system "./configure", *args
    system "make install"

    # build Graphviz.app
    cd "macosx" do
      system "xcodebuild", "-configuration", "Release", "SYMROOT=build", "PREFIX=#{prefix}", "ONLY_ACTIVE_ARCH=YES"
    end
    prefix.install "macosx/build/Release/Graphviz.app"
    (bin+'gvmap.sh').unlink
  end

  def test
    mktemp do
      (Pathname.pwd+'sample.dot').write <<-EOS.undent
      digraph G {
        a -> b
      }
      EOS

      system "#{bin}/dot", "-Tpdf", "-o", "sample.pdf", "sample.dot"
      system "/usr/bin/qlmanage", "-p", "./sample.pdf"
    end
  end

  def caveats; <<-EOS
    Graphviz.app was installed in:
      #{prefix}

    To symlink into ~/Applications, you can do:
      brew linkapps
    EOS
  end
end

# fix build on platforms without /usr/lib/libltdl.a (i.e., Lion)
# http://www.graphviz.org/mantisbt/view.php?id=2109
# fixed in upstream development version 2.29
# second part of DATA patch fixes quartz plugin build, may not be in upstream yet
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
diff --git a/plugin/quartz/Makefile.in b/plugin/quartz/Makefile.in
index 20ec9c6..dbeb46b 100644
--- a/plugin/quartz/Makefile.in
+++ b/plugin/quartz/Makefile.in
@@ -89,7 +89,7 @@ libgvplugin_quartz_la_OBJECTS = $(am_libgvplugin_quartz_la_OBJECTS)
 AM_V_lt = $(am__v_lt_$(V))
 am__v_lt_ = $(am__v_lt_$(AM_DEFAULT_VERBOSITY))
 am__v_lt_0 = --silent
-libgvplugin_quartz_la_LINK = $(LIBTOOL) $(AM_V_lt) $(AM_LIBTOOLFLAGS) \
+libgvplugin_quartz_la_LINK = $(LIBTOOL) $(AM_V_lt) --tag=CC $(AM_LIBTOOLFLAGS) \
	$(LIBTOOLFLAGS) --mode=link $(OBJCLD) $(AM_OBJCFLAGS) \
	$(OBJCFLAGS) $(libgvplugin_quartz_la_LDFLAGS) $(LDFLAGS) -o $@
 @WITH_QUARTZ_TRUE@@WITH_WIN32_FALSE@am_libgvplugin_quartz_la_rpath =  \
@@ -128,7 +128,7 @@ am__v_CCLD_ = $(am__v_CCLD_$(AM_DEFAULT_VERBOSITY))
 am__v_CCLD_0 = @echo "  CCLD  " $@;
 OBJCCOMPILE = $(OBJC) $(DEFS) $(DEFAULT_INCLUDES) $(INCLUDES) \
	$(AM_CPPFLAGS) $(CPPFLAGS) $(AM_OBJCFLAGS) $(OBJCFLAGS)
-LTOBJCCOMPILE = $(LIBTOOL) $(AM_V_lt) $(AM_LIBTOOLFLAGS) \
+LTOBJCCOMPILE = $(LIBTOOL) $(AM_V_lt) --tag=CC $(AM_LIBTOOLFLAGS) \
	$(LIBTOOLFLAGS) --mode=compile $(OBJC) $(DEFS) \
	$(DEFAULT_INCLUDES) $(INCLUDES) $(AM_CPPFLAGS) $(CPPFLAGS) \
	$(AM_OBJCFLAGS) $(OBJCFLAGS)
@@ -136,7 +136,7 @@ AM_V_OBJC = $(am__v_OBJC_$(V))
 am__v_OBJC_ = $(am__v_OBJC_$(AM_DEFAULT_VERBOSITY))
 am__v_OBJC_0 = @echo "  OBJC  " $@;
 OBJCLD = $(OBJC)
-OBJCLINK = $(LIBTOOL) $(AM_V_lt) $(AM_LIBTOOLFLAGS) $(LIBTOOLFLAGS) \
+OBJCLINK = $(LIBTOOL) $(AM_V_lt) --tag=CC $(AM_LIBTOOLFLAGS) $(LIBTOOLFLAGS) \
	--mode=link $(OBJCLD) $(AM_OBJCFLAGS) $(OBJCFLAGS) \
	$(AM_LDFLAGS) $(LDFLAGS) -o $@
 AM_V_OBJCLD = $(am__v_OBJCLD_$(V))
