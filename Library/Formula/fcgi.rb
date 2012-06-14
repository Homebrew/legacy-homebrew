require 'formula'

class Fcgi < Formula
  url 'http://www.fastcgi.com/dist/fcgi-2.4.0.tar.gz'
  homepage 'http://www.fastcgi.com/'
  md5 'd15060a813b91383a9f3c66faf84867e'

  def patches
    # https://trac.macports.org/browser/trunk/dports/www/fcgi/files/patch-libfcgi-fcgi_stdio.c.diff
    # Fixes "dyld: Symbol not found: _environ"
    # Affects programs linking this library. Reported at
    # http://mailman.fastcgi.com/pipermail/fastcgi-developers/2009-January/000152.html
    DATA
  end

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
