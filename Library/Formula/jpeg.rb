require 'formula'

class Jpeg < Formula
  homepage 'http://www.ijg.org'
  url 'http://www.ijg.org/files/jpegsrc.v9.tar.gz'
  sha1 '724987e7690ca3d74d6ab7c1f1b6854e88ca204b'

  option :universal

  #http://trac.macports.org/ticket/37984
  def patches
    DATA
  end

  def install
    ENV.universal_binary if build.universal?
    # Builds static and shared libraries.
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
--- a/jmorecfg.h
+++ b/jmorecfg.h
@@ -252,17 +252,16 @@ typedef void noreturn_t;
  * Defining HAVE_BOOLEAN before including jpeglib.h should make it work.
  */
 
-#ifdef HAVE_BOOLEAN
+#ifndef HAVE_BOOLEAN
+typedef int boolean;
+#endif
+
 #ifndef FALSE			/* in case these macros already exist */
 #define FALSE	0		/* values of boolean */
 #endif
 #ifndef TRUE
 #define TRUE	1
 #endif
-#else
-typedef enum { FALSE = 0, TRUE = 1 } boolean;
-#endif
-
 
 /*
  * The remaining options affect code selection within the JPEG library,

