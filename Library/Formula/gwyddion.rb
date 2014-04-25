require 'formula'

class Gwyddion < Formula
  homepage 'http://gwyddion.net/'
  url 'https://downloads.sourceforge.net/project/gwyddion/gwyddion/2.36/gwyddion-2.36.tar.xz'
  sha1 '0e81bbc3dbb0aadf5ab2ecb0606bd79a12681be2'

  depends_on :x11 => :optional
  depends_on 'pkg-config' => :build
  depends_on 'gtk+'
  depends_on 'libxml2'
  depends_on 'fftw'
  depends_on 'gtkglext'
  depends_on :python => :optional
  depends_on 'pygtk' if build.with? 'python'
  depends_on 'gtksourceview' if build.with? 'python'

  # Fixes the search path for the standalone Python module
  # See: <http://sourceforge.net/p/gwyddion/mailman/message/32267170/>
  patch :DATA

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-desktop-file-update",
                          "--prefix=#{prefix}",
                          "--with-html-dir=#{doc}"
    system "make install"
  end
end

__END__
--- a/modules/pygwy/gwy.c	(revision 16160)
+++ b/modules/pygwy/gwy.c	(working copy)
@@ -94,7 +94,7 @@
     guint i;

     for (i = 0; i < G_N_ELEMENTS(gwyddion_libs); i++) {
-        gchar *filename = g_strconcat(gwyddion_libs[i], ".", G_MODULE_SUFFIX,
+        gchar *filename = g_strconcat(gwyddion_libs[i], ".dylib",
                                       NULL);
         GModule *modhandle = g_module_open(filename, G_MODULE_BIND_LAZY);
         if (!modhandle) {
