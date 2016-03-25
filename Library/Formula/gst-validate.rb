class GstValidate < Formula
  desc "Tools to validate GstElements from GStreamer"
  homepage "https://gstreamer.freedesktop.org/data/doc/gstreamer/head/gst-validate/html/"
  url "https://gstreamer.freedesktop.org/src/gst-validate/gst-validate-1.8.0.tar.xz"
  sha256 "7666b777bd4b05efe4520ef92669169d8879f69a68606578ec667ae7dc4d9edd"

  bottle do
    sha256 "338d8f489811e92491ad6d86a96c76ac6056b6e178bb5caa412f73feff9b7d8f" => :el_capitan
    sha256 "46a75949ef97e6cfa1e1996886ebd34e1446752600e9308ce904ead70386ac19" => :yosemite
    sha256 "8d11ac9dc97c9f85f941ad6d684b3e2640795f02d02338562dd5e9a9da7f23f2" => :mavericks
  end

  head do
    url "https://anongit.freedesktop.org/git/gstreamer/gst-devtools.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gobject-introspection"
  depends_on "gstreamer"
  depends_on "gst-plugins-base"

  # fixes a missing library in a linker command
  # submitted upstream in https://bugzilla.gnome.org/show_bug.cgi?id=764192
  patch :DATA

  def install
    inreplace "tools/gst-validate-launcher.in", "env python2", "env python"

    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
    ]

    if build.head?
      ENV["NOCONFIGURE"] = "yes"
      cd "validate" do
        system "./autogen.sh"
        system "./configure", *args
        system "make"
        system "make", "install"
      end
    else
      system "./configure", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/gst-validate-launcher", "--usage"
  end
end

__END__
diff --git a/gst-libs/gst/video/Makefile.in b/gst-libs/gst/video/Makefile.in
index e55b8b1..0b1ee0f 100644
--- a/gst-libs/gst/video/Makefile.in
+++ b/gst-libs/gst/video/Makefile.in
@@ -487,7 +487,7 @@ validateplugindir = @validateplugindir@
 libgstvalidatevideo_@GST_API_VERSION@_la_SOURCES = gstvalidatessim.c gssim.c
 libgstvalidatevideo_@GST_API_VERSION@include_HEADERS = gstvalidatessim.h gssim.h
 libgstvalidatevideo_@GST_API_VERSION@_la_CFLAGS = $(GST_ALL_CFLAGS) $(CAIRO_CFLAGS) $(GST_VIDEO_CFLAGS) -I$(top_builddir)
-libgstvalidatevideo_@GST_API_VERSION@_la_LIBADD = $(GST_ALL_LIBS) $(CAIRO_LIBS) $(GST_VIDEO_LIBS) $(top_builddir)/gst/validate/libgstvalidate-@GST_API_VERSION@.la
+libgstvalidatevideo_@GST_API_VERSION@_la_LIBADD = $(GST_ALL_LIBS) $(CAIRO_LIBS) $(GST_VIDEO_LIBS) $(top_builddir)/gst/validate/libgstvalidate-@GST_API_VERSION@.la $(GIO_LIBS)
 libgstvalidatevideo_@GST_API_VERSION@_la_LDFLAGS = $(GST_ALL_LDFLAGS) $(CAIRO_LDFLAGS) $(GST_VIDEO_LDFLAGS)
 lib_LTLIBRARIES = libgstvalidatevideo-@GST_API_VERSION@.la
 libgstvalidatevideo_@GST_API_VERSION@includedir = $(includedir)/gstreamer-@GST_API_VERSION@/lib/validate/video
