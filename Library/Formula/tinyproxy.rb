require 'formula'

class Tinyproxy < Formula
  url 'https://www.banu.com/pub/tinyproxy/1.8/tinyproxy-1.8.3.tar.bz2'
  homepage 'https://www.banu.com/tinyproxy/'
  md5 '292ac51da8ad6ae883d4ebf56908400d'

  skip_clean 'var/run'

  depends_on 'asciidoc'

  def patches
     # LDFLAG '-z' not recognized
     # Tinyproxy switched to a2x and xmllint to build the man pages,
     # and it fails on some systems. The patch just tells xmllint to
     # ignore problems.
     DATA
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-regexcheck"
    system "make install"
  end
end

__END__
diff --git a/configure b/configure
index 79e7938..2aa5347 100755
--- a/configure
+++ b/configure
@@ -6745,7 +6745,6 @@ if test x"$debug_enabled" != x"yes" ; then
     CFLAGS="-DNDEBUG $CFLAGS"
 fi
 
-LDFLAGS="-Wl,-z,defs"
 
 
 if test x"$ac_cv_func_regexec" != x"yes"; then

diff --git a/docs/man5/Makefile.in b/docs/man5/Makefile.in
index eac9e6f..eb2a887 100644
--- a/docs/man5/Makefile.in
+++ b/docs/man5/Makefile.in
@@ -194,7 +194,7 @@ MAN5_FILES = \
 
 A2X_ARGS = \
 	-d manpage \
-	-f manpage
+	-f manpage -L
 
 man_MANS = \
 	$(MAN5_FILES:.txt=.5)
diff --git a/docs/man8/Makefile.in b/docs/man8/Makefile.in
index b51e93b..8957ccc 100644
--- a/docs/man8/Makefile.in
+++ b/docs/man8/Makefile.in
@@ -194,7 +194,7 @@ MAN8_FILES = \
 
 A2X_ARGS = \
 	-d manpage \
-	-f manpage
+	-f manpage -L
 
 man_MANS = \
 	$(MAN8_FILES:.txt=.8)
