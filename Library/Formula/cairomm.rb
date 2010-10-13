require 'formula'

class Cairomm <Formula
  url 'http://cairographics.org/releases/cairomm-1.8.4.tar.gz'
  homepage 'http://cairographics.org/cairomm/'
  md5 '559afbc47484ba3fad265e38a3dafe90'

  def patches
    { :p0 => DATA }
  end

  depends_on 'pkg-config' => :build
  depends_on 'libsigc++'
  # cairo is available on 10.6 via X11 but not on 10.5
  depends_on 'cairo' if MACOS_VERSION == 10.5

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-x",
            						  "--without-xlib",
            						  "--disable-quartz",
            						  "--disable-quartz-font"
    system "make install"
  end
end

# patch for universal compilation from:
# http://trac.macports.org/browser/trunk/dports/graphics/cairomm/files/patch-quartz-lp64.diff
__END__
diff -urN cairomm/quartz_font.cc cairomm-1.8.2/cairomm/quartz_font.cc
--- cairomm/quartz_font.cc	2008-12-20 18:37:46.000000000 +0100
+++ cairomm/quartz_font.cc	2009-09-20 17:45:13.000000000 +0200
@@ -30,21 +30,23 @@
   check_object_status_and_throw_exception(*this);
 }
 
-QuartzFontFace::QuartzFontFace(ATSUFontID font_id) :
-  FontFace(cairo_quartz_font_face_create_for_atsu_font_id(font_id), true)
+RefPtr<QuartzFontFace> QuartzFontFace::create(CGFontRef font)
 {
-  check_object_status_and_throw_exception(*this);
+  return RefPtr<QuartzFontFace>(new QuartzFontFace(font));
 }
 
-RefPtr<QuartzFontFace> QuartzFontFace::create(CGFontRef font)
+#if !__LP64__
+QuartzFontFace::QuartzFontFace(ATSUFontID font_id) :
+  FontFace(cairo_quartz_font_face_create_for_atsu_font_id(font_id), true)
 {
-  return RefPtr<QuartzFontFace>(new QuartzFontFace(font));
+  check_object_status_and_throw_exception(*this);
 }
 
 RefPtr<QuartzFontFace> QuartzFontFace::create(ATSUFontID font_id)
 {
   return RefPtr<QuartzFontFace>(new QuartzFontFace(font_id));
 }
+#endif
 
 }
 
diff cairomm/quartz_font.h cairomm-1.8.2/cairomm/quartz_font.h
--- cairomm/quartz_font.h	2008-12-20 18:37:46.000000000 +0100
+++ cairomm/quartz_font.h	2009-09-20 17:46:25.000000000 +0200
@@ -54,7 +54,9 @@
    *
    * @since 1.8
    */
+# if !__LP64__
   static RefPtr<QuartzFontFace> create(ATSUFontID font_id);
+# endif
 
 
 protected: