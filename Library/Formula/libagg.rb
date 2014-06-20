require 'formula'

class Libagg < Formula
  homepage 'http://www.antigrain.com'
  url 'http://www.antigrain.com/agg-2.5.tar.gz'
  sha1 '08f23da64da40b90184a0414369f450115cdb328'

  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build
  depends_on 'pkg-config' => :build
  depends_on 'sdl'
  depends_on 'freetype' => :optional

  # Fix build with clang; last release was in 2006
  patch :DATA

  def install
    # AM_C_PROTOTYPES was removed in automake 1.12, as it's only needed for
    # pre-ANSI compilers
    inreplace 'configure.in', 'AM_C_PROTOTYPES', ''
    inreplace 'autogen.sh', 'libtoolize', 'glibtoolize'

    system "sh", "autogen.sh",
                 "--disable-dependency-tracking",
                 "--prefix=#{prefix}",
                 "--disable-platform", # Causes undefined symbols
                 "--disable-ctrl",     # No need to run these during configuration
                 "--disable-examples",
                 "--disable-sdltest"
    system "make install"
  end
end

__END__
diff --git a/include/agg_renderer_outline_aa.h b/include/agg_renderer_outline_aa.h
index ce25a2e..9a12d35 100644
--- a/include/agg_renderer_outline_aa.h
+++ b/include/agg_renderer_outline_aa.h
@@ -1375,7 +1375,7 @@ namespace agg
         //---------------------------------------------------------------------
         void profile(const line_profile_aa& prof) { m_profile = &prof; }
         const line_profile_aa& profile() const { return *m_profile; }
-        line_profile_aa& profile() { return *m_profile; }
+        const line_profile_aa& profile() { return *m_profile; }
 
         //---------------------------------------------------------------------
         int subpixel_width() const { return m_profile->subpixel_width(); }
