require 'formula'

class Ggobi < Formula
  homepage 'http://www.ggobi.org'
  url 'http://www.ggobi.org/downloads/ggobi-2.1.9.tar.bz2'
  sha1 '0dd0fe0cf619c1404d024e019cf9c8d87fb4fe4b'

  depends_on 'pkg-config' => :build
  depends_on 'gtk+'
  depends_on 'glib'
  depends_on 'atk'
  depends_on 'cairo'
  depends_on 'fontconfig'
  depends_on 'pango'
  depends_on 'gettext'
  depends_on 'libtool' => :run
  depends_on :x11

  # Several files reference "line 0", which gcc accepts but clang doesn't
  # See https://github.com/Homebrew/homebrew/pull/13423
  patch :DATA

  def install
    # Necessary for ggobi to build - based on patch from MacPorts
    # See: https://trac.macports.org/export/64669/trunk/dports/science/ggobi/files/patch-src-texture.diff
    # Reported at https://groups.google.com/d/msg/ggobi/0yiepEUgjiM/nXTVoMaAzj8J
    inreplace 'src/texture.c', 'psort', 'p_sort'
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-all-plugins"
    system "make install"
  end
end

__END__
diff --git a/src/ggobi-data.c b/src/ggobi-data.c
index ccb52dc..fbd756e 100644
--- a/src/ggobi-data.c
+++ b/src/ggobi-data.c
@@ -42,7 +42,7 @@ typedef GGobiDataClass SelfClass;
 /* here are local prototypes */
 static void ___object_set_property (GObject *object, guint property_id, const GValue *value, GParamSpec *pspec);
 static void ___object_get_property (GObject *object, guint property_id, GValue *value, GParamSpec *pspec);
-#line 0 "data.gob"
+#line 1 "data.gob"
 static void ggobi_data_class_init (GGobiDataClass * c) G_GNUC_UNUSED;
 #line 48 "ggobi-data.c"
 #line 191 "data.gob"
diff --git a/src/ggobi-renderer-cairo.c b/src/ggobi-renderer-cairo.c
index 0b51ab6..12a47cf 100644
--- a/src/ggobi-renderer-cairo.c
+++ b/src/ggobi-renderer-cairo.c
@@ -57,10 +57,10 @@ struct _GGobiRendererCairoPrivate {
 /* here are local prototypes */
 static void ___object_set_property (GObject *object, guint property_id, const GValue *value, GParamSpec *pspec);
 static void ___object_get_property (GObject *object, guint property_id, GValue *value, GParamSpec *pspec);
-#line 0 "renderer-cairo.gob"
+#line 1 "renderer-cairo.gob"
 static void ggobi_renderer_cairo_init (GGobiRendererCairo * o) G_GNUC_UNUSED;
 #line 63 "ggobi-renderer-cairo.c"
-#line 0 "renderer-cairo.gob"
+#line 1 "renderer-cairo.gob"
 static void ggobi_renderer_cairo_class_init (GGobiRendererCairoClass * c) G_GNUC_UNUSED;
 #line 66 "ggobi-renderer-cairo.c"
 #line 36 "renderer-cairo.gob"
diff --git a/src/ggobi-renderer-factory.c b/src/ggobi-renderer-factory.c
index ee1c93e..5be74bf 100644
--- a/src/ggobi-renderer-factory.c
+++ b/src/ggobi-renderer-factory.c
@@ -44,10 +44,10 @@ typedef GGobiRendererFactory Self;
 typedef GGobiRendererFactoryClass SelfClass;
 
 /* here are local prototypes */
-#line 0 "renderer-factory.gob"
+#line 1 "renderer-factory.gob"
 static void ggobi_renderer_factory_init (GGobiRendererFactory * o) G_GNUC_UNUSED;
 #line 50 "ggobi-renderer-factory.c"
-#line 0 "renderer-factory.gob"
+#line 1 "renderer-factory.gob"
 static void ggobi_renderer_factory_class_init (GGobiRendererFactoryClass * c) G_GNUC_UNUSED;
 #line 53 "ggobi-renderer-factory.c"
 static GGobiRenderer * ___real_ggobi_renderer_factory_create (GGobiRendererFactory * self, GdkDrawable * parent);
diff --git a/src/ggobi-renderer.c b/src/ggobi-renderer.c
index 1231145..7174c13 100644
--- a/src/ggobi-renderer.c
+++ b/src/ggobi-renderer.c
@@ -51,7 +51,7 @@ struct _GGobiRendererPrivate {
 /* here are local prototypes */
 static void ___object_set_property (GObject *object, guint property_id, const GValue *value, GParamSpec *pspec);
 static void ___object_get_property (GObject *object, guint property_id, GValue *value, GParamSpec *pspec);
-#line 0 "renderer.gob"
+#line 1 "renderer.gob"
 static void ggobi_renderer_init (GGobiRenderer * o) G_GNUC_UNUSED;
 #line 57 "ggobi-renderer.c"
 static GdkDrawable * ___real_ggobi_renderer_create_target (GGobiRenderer * self, GdkDrawable * parent);
