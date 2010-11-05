require 'formula'

class Wireshark <Formula
  url 'http://media-2.cacetech.com/wireshark/src/wireshark-1.4.1.tar.bz2'
  md5 '1719d20a10990e7c2cb261df7021aab6'
  homepage 'http://www.wireshark.org'

  depends_on 'gnutls' => :optional
  depends_on 'pcre' => :optional
  depends_on 'glib'
  depends_on 'gtk+' if ARGV.include? "--with-x"

  def options
    [["--with-x", "Include X11 support"]]
  end

  def patches
    # Fix a crash on launch bug in 1.4.1 as fixed in wireshark SVN revision 34494
    DATA
  end

  def install
    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]

    # actually just disables the GTK GUI
    args << "--disable-wireshark" if not ARGV.include? "--with-x"

    system "./configure", *args
    system "make"
    ENV.j1 # Install failed otherwise.
    system "make install"
  end
end


__END__
--- trunk-1.4/gtk/main.c	2010/10/12 21:33:08	34493
+++ trunk-1.4/gtk/main.c	2010/10/13 00:50:07	34494
@@ -2787,7 +2787,6 @@
      changed either from one of the preferences file or from the command
      line that their preferences have changed. */
   prefs_apply_all();
-  macros_post_update();
 
   /* disabled protocols as per configuration file */
   if (gdp_path == NULL && dp_path == NULL) {
@@ -3731,6 +3730,7 @@
 
    prefs_to_capture_opts();
    prefs_apply_all();
+   macros_post_update();
 
    /* Update window view and redraw the toolbar */
    update_main_window_name();
