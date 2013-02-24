require 'formula'

class Pango < Formula
  homepage 'http://www.pango.org/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/pango/1.32/pango-1.32.6.tar.xz'
  sha256 '8e9a3eadebf30a31640f2b3ae0fb455cf92d10d1cad246d0ffe72ec595905174'

  option 'without-x', 'Build without X11 support'

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'glib'
  depends_on 'harfbuzz'

  unless build.include? 'without-x'
    depends_on :x11
    # Needs fontconfig 2.10.91, which is newer than what XQuartz provides
    depends_on 'fontconfig'
  end

  # The Cairo library shipped with Lion contains a flaw that causes Graphviz
  # to segfault. See the following ticket for information:
  #   https://trac.macports.org/ticket/30370
  # We depend on our cairo on all platforms for consistency
  depends_on 'cairo'

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  # Fixes hanging of inkscape, already upstream for next version.
  # https://bugs.launchpad.net/inkscape/+bug/1114392
  # http://git.gnome.org/browse/pango/commit/?id=10cc6557ba24239570ee9a7bcaa0a553aae9df95
  def patches
    DATA
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-man
      --with-html-dir=#{share}/doc
      --disable-introspection
    ]

    if build.include? 'without-x'
      args << '--without-xft'
    else
      args << '--with-xft'
    end

    system "./configure", *args
    system "make"
    system "make install"
  end

  def test
    system "#{bin}/pango-querymodules", "--version"
  end
end
__END__
diff --git a/pango/pangoft2-render.c b/pango/pangoft2-render.c
index 60cf432..42923f4 100644
--- a/pango/pangoft2-render.c
+++ b/pango/pangoft2-render.c
@@ -210,7 +210,7 @@ pango_ft2_font_render_glyph (PangoFont *font,
       return box;
     }

-  face = pango_fc_font_lock_face (PANGO_FC_FONT (font));
+  face = pango_ft2_font_get_face (font);

   if (face)
     {
@@ -231,8 +231,6 @@ pango_ft2_font_render_glyph (PangoFont *font,
       rendered->bitmap_left = face->glyph->bitmap_left;
       rendered->bitmap_top = face->glyph->bitmap_top;

-      pango_fc_font_unlock_face (PANGO_FC_FONT (font));
-
       if (G_UNLIKELY (!rendered->bitmap.buffer)) {
         g_slice_free (PangoFT2RenderedGlyph, rendered);
	return NULL;
@@ -242,8 +240,6 @@ pango_ft2_font_render_glyph (PangoFont *font,
     }
   else
     {
-      pango_fc_font_unlock_face (PANGO_FC_FONT (font));
-
 generic_box:
       return  pango_ft2_font_render_box_glyph (PANGO_UNKNOWN_GLYPH_WIDTH,
					       PANGO_UNKNOWN_GLYPH_HEIGHT,
diff --git a/pango/pangoft2.c b/pango/pangoft2.c
index cbe1d21..dc6db5d 100644
--- a/pango/pangoft2.c
+++ b/pango/pangoft2.c
@@ -424,13 +424,12 @@ pango_ft2_font_get_kerning (PangoFont *font,
 static FT_Face
 pango_ft2_font_real_lock_face (PangoFcFont *font)
 {
-  return pango_fc_font_lock_face (font);
+  return pango_ft2_font_get_face ((PangoFont *)font);
 }

 static void
-pango_ft2_font_real_unlock_face (PangoFcFont *font)
+pango_ft2_font_real_unlock_face (PangoFcFont *font G_GNUC_UNUSED)
 {
-  pango_fc_font_unlock_face (font);
 }

 static gboolean
@@ -500,18 +499,12 @@ pango_ft2_font_get_coverage (PangoFont     *font,
 PangoGlyph
 pango_ft2_get_unknown_glyph (PangoFont *font)
 {
-  PangoFcFont *fc_font = PANGO_FC_FONT (font);
-  FT_Face face;
-  PangoGlyph glyph;
-
-  face = pango_fc_font_lock_face (fc_font);
+  FT_Face face = pango_ft2_font_get_face (font);
   if (face && FT_IS_SFNT (face))
     /* TrueType fonts have an 'unknown glyph' box on glyph index 0 */
-    glyph = 0;
+    return 0;
   else
-    glyph = PANGO_GLYPH_EMPTY;
-  pango_fc_font_unlock_face (fc_font);
-  return glyph;
+    return PANGO_GLYPH_EMPTY;
 }

 typedef struct
