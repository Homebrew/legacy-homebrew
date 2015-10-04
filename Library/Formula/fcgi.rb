class Fcgi < Formula
  desc "Protocol for interfacing interactive programs with a web server"
  homepage "http://www.fastcgi.com/"
  url "http://www.fastcgi.com/dist/fcgi-2.4.0.tar.gz"
  sha256 "66fc45c6b36a21bf2fbbb68e90f780cc21a9da1fffbae75e76d2b4402d3f05b9"

  # Fixes "dyld: Symbol not found: _environ"
  # Affects programs linking this library. Reported at
  # http://mailman.fastcgi.com/pipermail/fastcgi-developers/2009-January/000152.html
  # https://trac.macports.org/browser/trunk/dports/www/fcgi/files/patch-libfcgi-fcgi_stdio.c.diff
  patch :DATA

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
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
