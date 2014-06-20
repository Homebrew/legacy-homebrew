require 'formula'

class Fcgi < Formula
  homepage 'http://www.fastcgi.com/'
  url 'http://www.fastcgi.com/dist/fcgi-2.4.0.tar.gz'
  sha1 '2329404159e8b8315e524b9eaf1de763202c6e6a'

  # Fixes "dyld: Symbol not found: _environ"
  # Affects programs linking this library. Reported at
  # http://mailman.fastcgi.com/pipermail/fastcgi-developers/2009-January/000152.html
  # https://trac.macports.org/browser/trunk/dports/www/fcgi/files/patch-libfcgi-fcgi_stdio.c.diff
  patch :DATA

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
--- a/libfcgi/fcgi_stdio.c
+++ b/libfcgi/fcgi_stdio.c
@@ -40,7 +40,12 @@

 #ifndef _WIN32

+#if defined(__APPLE__)
+#include <crt_externs.h>
+#define environ (*_NSGetEnviron())
+#else
 extern char **environ;
+#endif

 #ifdef HAVE_FILENO_PROTO
 #include <stdio.h>
