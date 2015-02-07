class Libmatroska < Formula
  homepage "http://www.matroska.org/"

  stable do
    url "http://dl.matroska.org/downloads/libmatroska/libmatroska-1.4.2.tar.bz2"
    mirror "https://www.bunkus.org/videotools/mkvtoolnix/sources/libmatroska-1.4.2.tar.bz2"
    sha256 "bea10320f1f1fd121bbd7db9ffc77b2518e8269f00903549c5425478bbf8393f"

    # Apply upstream patch to link against libEBML
    # https://github.com/Matroska-Org/libmatroska/commit/9466bf5f2b
    patch :DATA
  end

  head do
    url "https://github.com/Matroska-Org/libmatroska.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  bottle do
    cellar :any
    revision 1
    sha1 "d39ff1121fdf2be3602e355e348d75c97834c03e" => :yosemite
    sha1 "3692b1c928884da200d91bc4158d3a0c340baaa9" => :mavericks
    sha1 "4b99118975bfd6c0cf9df4e35e62e33eafb787ac" => :mountain_lion
  end

  option :cxx11

  if build.cxx11?
    depends_on "libebml" => "c++11"
  else
    depends_on "libebml"
  end

  depends_on "pkg-config" => :build

  def install
    ENV.cxx11 if build.cxx11?

    system "autoreconf", "-fi" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end

__END__
diff --git a/Makefile.am b/Makefile.am
index f3b881d..c6a728d
--- a/Makefile.am
+++ b/Makefile.am
@@ -27,6 +27,7 @@ libmatroska_la_SOURCES = \
	src/KaxTracks.cpp \
	src/KaxVersion.cpp
 libmatroska_la_LDFLAGS = -version-info 6:0:0 -no-undefined
+libmatroska_la_LIBADD = $(EBML_LIBS)

 nobase_include_HEADERS = \
	matroska/c/libmatroska.h \
diff --git a/Makefile.in b/Makefile.in
index dc52565..e677a4f 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -141,7 +141,8 @@ am__uninstall_files_from_dir = { \
 am__installdirs = "$(DESTDIR)$(libdir)" "$(DESTDIR)$(pkgconfigdir)" \
	"$(DESTDIR)$(includedir)"
 LTLIBRARIES = $(lib_LTLIBRARIES)
-libmatroska_la_LIBADD =
+am__DEPENDENCIES_1 =
+libmatroska_la_DEPENDENCIES = $(am__DEPENDENCIES_1)
 am__dirstamp = $(am__leading_dot)dirstamp
 am_libmatroska_la_OBJECTS = src/FileKax.lo src/KaxAttached.lo \
	src/KaxAttachments.lo src/KaxBlock.lo src/KaxBlockData.lo \
@@ -387,6 +398,7 @@ libmatroska_la_SOURCES = \
	src/KaxVersion.cpp

 libmatroska_la_LDFLAGS = -version-info 6:0:0 -no-undefined
+libmatroska_la_LIBADD = $(EBML_LIBS)
 nobase_include_HEADERS = \
	matroska/c/libmatroska.h \
	matroska/c/libmatroska_t.h \
