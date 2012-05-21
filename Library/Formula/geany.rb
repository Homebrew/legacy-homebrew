require 'formula'

class Geany < Formula
  homepage 'http://geany.org/'
  url 'http://download.geany.org/geany-0.21.tar.gz'
  sha256 'a1aa27d2f946ccca8a4e57faf0029cf6aa544d5d52f0170e017c137c33b4b67d'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'intltool'
  depends_on 'gtk+'

  # Part of the patch for glib.  Remove at geany-0.22
  if MacOS.xcode_version >= '4.3'
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # Fix for compiling against glib > 2.31.  Reported in #12345.  Fixed in HEAD.
  # Remove at geany-0.22.  From https://github.com/geany/geany/commit/7b2f0fe5ae
  def patches
    DATA
  end

  def install
    intltool = Formula.factory('intltool')
    ENV.append "PATH", intltool.bin, ":"

    # Part of the patch for glib.  Remove both lines at geany-0.22.
    ENV['NOCONFIGURE'] = '1'
    system './autogen.sh'

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
--- a/configure.ac	2011-10-02 06:21:30.000000000 -0700
+++ b/configure.ac	2012-05-21 14:12:18.000000000 -0700
@@ -134,7 +134,7 @@
 
 
 # GTK/GLib/GIO checks
-gtk_modules="gtk+-2.0 >= 2.12 glib-2.0 >= 2.16 gio-2.0 >= 2.16"
+gtk_modules="gtk+-2.0 >= 2.12 glib-2.0 >= 2.16 gio-2.0 >= 2.16 gmodule-2.0"
 PKG_CHECK_MODULES(GTK, [$gtk_modules])
 AC_SUBST(GTK_CFLAGS)
 AC_SUBST(GTK_LIBS)
--- a/wscript	2011-10-02 06:21:30.000000000 -0700
+++ b/wscript	2012-05-21 14:02:08.000000000 -0700
@@ -145,6 +145,8 @@
         mandatory=True, args='--cflags --libs')
     conf.check_cfg(package='glib-2.0', atleast_version='2.16.0', uselib_store='GLIB',
         mandatory=True, args='--cflags --libs')
+    conf.check_cfg(package='gmodule-2.0', uselib_store='GMODULE',
+        mandatory=True, args='--cflags --libs')
     conf.check_cfg(package='gio-2.0', uselib_store='GIO', args='--cflags --libs', mandatory=True)
     gtk_version = conf.check_cfg(modversion='gtk+-2.0', uselib_store='GTK') or 'Unknown'
     conf.check_cfg(package='gthread-2.0', uselib_store='GTHREAD', args='--cflags --libs')
@@ -271,7 +273,7 @@
             includes                = ['.', 'src/', 'scintilla/include', 'tagmanager/include'],
             defines                 = 'G_LOG_DOMAIN="%s"' % plugin_name,
             target                  = plugin_name,
-            uselib                  = ['GTK', 'GLIB'],
+            uselib                  = ['GTK', 'GLIB', 'GMODULE'],
             install_path            = instpath)
 
 
@@ -328,7 +330,8 @@
         source          = geany_sources,
         includes        = ['.', 'scintilla/include/', 'tagmanager/include/'],
         defines         = ['G_LOG_DOMAIN="Geany"', 'GEANY_PRIVATE'],
-        uselib          = ['GTK', 'GLIB', 'GIO', 'GTHREAD', 'WIN32', 'SUNOS_SOCKET'],
+        linkflags       = [] if is_win32 else ['-Wl,--export-dynamic'],
+        uselib          = ['GTK', 'GLIB', 'GMODULE', 'GIO', 'GTHREAD', 'WIN32', 'SUNOS_SOCKET'],
         use             = ['scintilla', 'tagmanager', 'mio'])
 
     # geanyfunctions.h
