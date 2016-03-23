class Fcgi < Formula
  desc "Protocol for interfacing interactive programs with a web server"
  homepage "http://www.fastcgi.com/"
  url "http://ftp.gwdg.de/pub/linux/gentoo/distfiles/fcgi-2.4.0.tar.gz"
  sha256 "66fc45c6b36a21bf2fbbb68e90f780cc21a9da1fffbae75e76d2b4402d3f05b9"

  bottle do
    cellar :any
    sha256 "27b723d2451b163cf1c5b8c461b6b550b9c4fcdd8dfd9e9f9c20477cb50d3da7" => :el_capitan
    sha256 "ad01d3980edafd7330a41b008e95e4af24708ac0a6b8bb625160635d6f36c4a3" => :yosemite
    sha256 "58b93f834db071aac4831e73d7f34f59a73759a453676ca66b187135e8da7f36" => :mavericks
  end

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
