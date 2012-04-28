require 'formula'

class Mcpp < Formula
  url 'http://downloads.sourceforge.net/project/mcpp/mcpp/V.2.7.2/mcpp-2.7.2.tar.gz'
  homepage 'http://mcpp.sourceforge.net/'
  md5 '512de48c87ab023a69250edc7a0c7b05'

  # stpcpy is a macro on OS X; trying to define it as an extern is invalid.
  def patches; DATA; end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--enable-mcpplib"
    system "make install"
  end
end

__END__
diff -ur mcpp-2.7.2-orig/src/internal.H mcpp-2.7.2/src/internal.H
--- mcpp-2.7.2-orig/src/internal.H	2008-08-27 08:01:16.000000000 -0500
+++ mcpp-2.7.2/src/internal.H	2010-11-08 15:53:38.000000000 -0600
@@ -557,6 +557,6 @@
 #endif
 #endif
 
-#if HOST_HAVE_STPCPY
+#if HOST_HAVE_STPCPY && !defined(stpcpy)
 extern char *   stpcpy( char * dest, const char * src);
 #endif
