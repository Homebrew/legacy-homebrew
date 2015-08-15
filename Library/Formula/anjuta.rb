class Anjuta < Formula
  desc "GNOME Integrated Development Environment"
  homepage "http://anjuta.org"
  url "https://download.gnome.org/sources/anjuta/3.16/anjuta-3.16.0.tar.xz"
  sha256 "77432a01b37b46f5558bf4cc435f9a023abf17c5273d472e17dff1f9b3d9943c"

  bottle do
    revision 1
    sha256 "b19db8006b5ac7f253e3d548a213eef974b94357a8797de5a4702454f4098392" => :yosemite
    sha256 "1b169dce85612b811e3e27395a45140ef8a9b70f0d229804f57f00b72b1151f3" => :mavericks
    sha256 "f845183ca3a722b08b7aff7d729d9457d3b0a353072eb41cc43025d8dad9bbd0" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gtk-doc" => :build
  depends_on "yelp-tools" => :build
  depends_on "gnome-common" => :build
  depends_on "bison" => :build
  depends_on "gtksourceview3"
  depends_on "libxml2" => "with-python"
  depends_on "libgda"
  depends_on "gdl"
  depends_on "vte3"
  depends_on "hicolor-icon-theme"
  depends_on "gnome-icon-theme"
  depends_on "shared-mime-info"
  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "vala" => :recommended
  depends_on "autogen" => :recommended

  # patch submitted upstream at https://bugzilla.gnome.org/show_bug.cgi?id=752763
  patch :DATA

  def install
    ENV["NOCONFIGURE"] = "1"
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-schemas-compile"
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python2.7/site-packages"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/HighContrast"
    system "#{Formula["shared-mime-info"].opt_bin}/update-mime-database", "#{HOMEBREW_PREFIX}/share/mime"
  end

  test do
    system "#{bin}/anjuta", "--version"
  end
end

__END__
diff --git a/configure.ac b/configure.ac
index d4b90c2..207681c 100644
--- a/configure.ac
+++ b/configure.ac
@@ -484,11 +484,14 @@ dnl Checks for typedefs, structures, and compiler characteristics.
 AC_CANONICAL_HOST
 CYGWIN=no
 MINGW32=no
+MACOSX=no
 case $host_os in
   *cygwin* ) CYGWIN=yes;;
   *mingw32* ) MINGW32=yes;;
+  *darwin* ) MACOSX=yes;;
 esac

+AM_CONDITIONAL([MACOSX],[test x$MACOSX = xyes])

 dnl Check for bind in libsocket (needed on Solaris)
 AC_CHECK_LIB(socket, bind)
diff --git a/plugins/am-project/Makefile.am b/plugins/am-project/Makefile.am
index b5f5f5d..5068739 100644
--- a/plugins/am-project/Makefile.am
+++ b/plugins/am-project/Makefile.am
@@ -94,7 +94,7 @@ am-parser.c: $(srcdir)/am-parser.y
 am-scanner.h: am-parser.c

 # Test program
-
+if !MACOSX
 noinst_PROGRAMS = projectparser

 projectparser_SOURCES = \
@@ -105,6 +105,7 @@ projectparser_LDADD = \
	$(GIO_LIBS) \
	$(LIBANJUTA_LIBS) \
	$(ANJUTA_LIBS)
+endif

 EXTRA_DIST = \
	$(plugin_in_files) \
diff --git a/plugins/indentation-c-style/Makefile.am b/plugins/indentation-c-style/Makefile.am
index 5ae8e96..4ad76e3 100644
--- a/plugins/indentation-c-style/Makefile.am
+++ b/plugins/indentation-c-style/Makefile.am
@@ -50,6 +50,8 @@ libanjuta_indentation_c_style_la_SOURCES = \
	indentation.h

 libanjuta_indentation_c_style_la_LDFLAGS = $(ANJUTA_PLUGIN_LDFLAGS)
+libanjuta_indentation_c_style_la_LIBADD = \
+        $(LIBANJUTA_LIBS)

 gsettings_in_file = org.gnome.anjuta.plugins.indent-c.gschema.xml.in
 gsettings_SCHEMAS = $(gsettings_in_file:.xml.in=.xml)
diff --git a/plugins/jhbuild/Makefile.am b/plugins/jhbuild/Makefile.am
index 62f4370..bf56211 100644
--- a/plugins/jhbuild/Makefile.am
+++ b/plugins/jhbuild/Makefile.am
@@ -38,7 +38,8 @@ libanjuta_jhbuild_la_SOURCES = \
	plugin.h

 libanjuta_jhbuild_la_LDFLAGS = $(ANJUTA_PLUGIN_LDFLAGS)
-
+libanjuta_jhbuild_la_LIBADD = \
+        $(LIBANJUTA_LIBS)

 EXTRA_DIST = \
	$(plugin_in_files)
diff --git a/plugins/symbol-db/benchmark/libgda/Makefile.am b/plugins/symbol-db/benchmark/libgda/Makefile.am
index 2a011e2..77dd800 100644
--- a/plugins/symbol-db/benchmark/libgda/Makefile.am
+++ b/plugins/symbol-db/benchmark/libgda/Makefile.am
@@ -1,3 +1,4 @@
+if !MACOSX
 noinst_PROGRAMS = \
	benchmark-libgda

@@ -16,7 +17,7 @@ benchmark_libgda_LDFLAGS = \
	$(GDA_LIBS)

 benchmark_libgda_LDADD = ../../libanjuta-symbol-db.la
-
+endif

 ## File created by the gnome-build tools

diff --git a/plugins/symbol-db/benchmark/symbol-db/Makefile.am b/plugins/symbol-db/benchmark/symbol-db/Makefile.am
index c49665a..788b85b 100644
--- a/plugins/symbol-db/benchmark/symbol-db/Makefile.am
+++ b/plugins/symbol-db/benchmark/symbol-db/Makefile.am
@@ -1,3 +1,4 @@
+if !MACOSX
 noinst_PROGRAMS = \
	benchmark

@@ -16,7 +17,7 @@ benchmark_LDFLAGS = \
	$(GDA_LIBS)

 benchmark_LDADD = ../../libanjuta-symbol-db.la
-
+endif

 ## File created by the gnome-build tools
