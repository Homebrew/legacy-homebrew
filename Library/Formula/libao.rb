require 'formula'

class Libao <Formula
  @url='http://downloads.xiph.org/releases/ao/libao-0.8.8.tar.gz'
  @md5='b92cba3cbcf1ee9bc221118a85d23dcd'
  @homepage='http://www.xiph.org/ao/'

  def patches
    # Fix this: dyld: lazy symbol binding failed: Symbol not found: _dlsym_auto_underscore
    # See: http://trac.macports.org/ticket/20891
    DATA
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--disable-x"
    system "make install"
  end
end


__END__
--- a/configure	2007-05-24 12:51:52.000000000 +0200
+++ b/configure	2007-11-30 21:54:58.000000000 +0100
@@ -20094,9 +20094,10 @@
                 PROFILE="-pg -g -O20 -D__NO_MATH_INLINES -fsigned-char" ;;
         *-darwin*)
                 PLUGIN_LDFLAGS="-module -avoid-version"
-                DEBUG="-g -Wall -D__NO_MATH_INLINES -fsigned-char -Ddlsym=dlsym_auto_underscore"
-                CFLAGS="-D__NO_MATH_INLINES -fsigned-char -Ddlsym=dlsym_auto_underscore"
-                PROFILE="-g -pg -D__NO_MATH_INLINES -fsigned-char -Ddlsym=dlsym_auto_underscore" ;;
+                DEBUG="-g -Wall -D__NO_MATH_INLINES -fsigned-char"
+                CFLAGS="-D__NO_MATH_INLINES -fsigned-char"
+                PROFILE="-g -pg -D__NO_MATH_INLINES -fsigned-char"
+                LIBS="-Wl,-framework -Wl,AudioUnit" ;;
         *)
                 PLUGIN_LDFLAGS="-export-dynamic -avoid-version"
                 DEBUG="-g -Wall -D__NO_MATH_INLINES -fsigned-char"
@@ -20203,7 +20204,7 @@
 	DLOPEN_FLAG='(RTLD_LAZY)'
 	SHARED_LIB_EXT='.sl'
 	;;
-    *openbsd* | *netbsd* | *solaris2.7)
+    *openbsd* | *netbsd* | *solaris2.7 | *darwin*)
 	DLOPEN_FLAG='(RTLD_LAZY)'
 	SHARED_LIB_EXT='.so'
 	;;
