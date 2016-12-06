require 'formula'

class Klavaro < Formula
  url 'http://downloads.sourceforge.net/project/klavaro/klavaro-1.9.2.tar.bz2'
  homepage 'http://klavaro.sourceforge.net/'
  md5 'd13101c68ae84672ef45b6563c56da81'

  depends_on 'gtk+'
  depends_on 'gtkdatabox'
  depends_on 'intltool'  
  depends_on 'gettext'  

  # Avoid strip, strip causes 'Gtk-WARNING **: Could not find signal handler' errors
  skip_clean 'bin'

  def patches
      DATA
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
diff --git a/src/Makefile.in b/src/Makefile.in
index 4b3a9b7..e22dac5 100644
--- a/src/Makefile.in
+++ b/src/Makefile.in
@@ -59,7 +59,7 @@ am__mv = mv -f
 COMPILE = $(CC) $(DEFS) $(DEFAULT_INCLUDES) $(INCLUDES) $(AM_CPPFLAGS) \
        $(CPPFLAGS) $(AM_CFLAGS) $(CFLAGS)
 CCLD = $(CC)
-LINK = $(CCLD) $(AM_CFLAGS) $(CFLAGS) $(AM_LDFLAGS) $(LDFLAGS) -o $@
+LINK = $(CCLD) $(subst -export-dynamic,--export-dynamic, $(AM_CFLAGS)) $(CFLAGS) $(AM_LDFLAGS) $(LDFLAGS) -o $@
 SOURCES = $(klavaro_SOURCES)
 DIST_SOURCES = $(klavaro_SOURCES)
 ETAGS = etags
diff --git a/src/tutor.c b/src/tutor.c
index cd22e84..298bc73 100644
--- a/src/tutor.c
+++ b/src/tutor.c
@@ -984,8 +984,8 @@ tutor_calc_stats ()
	// Begin the accuracy
	tmp_str = g_strconcat ("\n", _("STATISTICS"), "\n",
 			       _("Elapsed time:"), " %i ",
-			       dngettext (PACKAGE, "minute and", "minutes and", minutes),
-			       " %i ", dngettext (PACKAGE, "second", "seconds", seconds),
+			       "minutes and",
+			       " %i ", "seconds",
 			       "\n", _("Error ratio:"), " %i/%i\n", _("Accuracy:"), " ", NULL);
 
	tmp_str2 = g_strdup_printf (tmp_str, minutes, seconds, tutor.n_errors, tutor.n_touchs);
