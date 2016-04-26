class GstValidate < Formula
  desc "Tools to validate GstElements from GStreamer"
  homepage "https://gstreamer.freedesktop.org/data/doc/gstreamer/head/gst-validate/html/"
  url "https://gstreamer.freedesktop.org/src/gst-validate/gst-validate-1.8.0.tar.xz"
  sha256 "7666b777bd4b05efe4520ef92669169d8879f69a68606578ec667ae7dc4d9edd"

  bottle do
    sha256 "ed59fc8ba0c857f6b3f275737ad073ab98346e81a1f178f5777ff7a3985cf063" => :el_capitan
    sha256 "e8f3aaf0af57de6ed06b19270d0018c5941852bd147d0eb64849a60843bf699b" => :yosemite
    sha256 "cb61b41c0f50e1369e6f982ca726b89ab849b436c4c3fd2effc3d24a50e0e7f1" => :mavericks
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
