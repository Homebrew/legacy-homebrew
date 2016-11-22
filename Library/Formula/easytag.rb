require 'formula'

# EasyTAG is a utility for viewing and editing tags for MP3, MP2, MP4/AAC, FLAC, Ogg Vorbis, MusePack, Monkey's Audio and WavPack files.
class Easytag <Formula
  url 'http://archive.ubuntu.com/ubuntu/pool/universe/e/easytag/easytag_2.1.6.orig.tar.gz'
  homepage 'http://easytag.sf.net'
  md5 '91b57699ac30c1764af33cc389a64c71'

  depends_on 'glib'
  depends_on 'gtk+'
  depends_on 'id3lib'
  depends_on 'libid3tag'
  depends_on 'mp4v2'
  
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
--- a/configure
+++ b/configure
@@ -22471,7 +22471,7 @@ fi
 
                 cat >conftest.$ac_ext <<_ACEOF
 
-           #include <mp4.h>
+           #include <mp4v2/mp4v2.h>
            main () {
            MP4FileHandle hFile;
            MP4GetMetadataCoverArt(hFile, NULL, NULL,0); }
--- a/configure.in
+++ b/configure.in
@@ -357,7 +357,7 @@ if test "x$enable_mp4" = "xyes"; then
 
         dnl Version 1.6 of libmp4v2 introduces an index argument for MP4GetMetadataCoverart. So we define 'NEWMP4' if it is the case
         AC_COMPILE_IFELSE([
-           #include <mp4.h>
+           #include <mp4v2/mp4v2.h>
            main () {
            MP4FileHandle hFile;
            MP4GetMetadataCoverArt(hFile, NULL, NULL,0); }
--- a/src/mp4_header.c
+++ b/src/mp4_header.c
@@ -44,7 +44,7 @@
 #undef PACKAGE_STRING
 #undef PACKAGE_TARNAME
 #undef PACKAGE_VERSION
-#include <mp4.h>
+#include <mp4v2/mp4v2.h>
 
 
 /****************
--- a/src/mp4_tag.c
+++ b/src/mp4_tag.c
@@ -50,7 +50,7 @@
 #undef PACKAGE_STRING
 #undef PACKAGE_TARNAME
 #undef PACKAGE_VERSION
-#include <mp4.h>
+#include <mp4v2/mp4v2.h>
 
 
 /****************
