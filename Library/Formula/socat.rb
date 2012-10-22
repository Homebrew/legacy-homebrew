require 'formula'

class Socat < Formula
  homepage 'http://www.dest-unreach.org/socat/'
  url 'http://www.dest-unreach.org/socat/download/socat-1.7.2.1.tar.bz2'
  sha1 'c48cbba5e4d20fcf04b327e40d878b7322be82fd'

  devel do
    url 'http://www.dest-unreach.org/socat/download/socat-2.0.0-b5.tar.bz2'
    sha1 'd75c0abc816f9bb8ee1e36f6ca4fe58d7e56f2a4'
  end

  depends_on 'readline'

  def patches
    # Socat devs are aware; see:
    # https://trac.macports.org/ticket/32044
    p = { :p0 => "https://trac.macports.org/export/90442/trunk/dports/sysutils/socat/files/patch-xioexit.c.diff" }
    p[:p1] = DATA if build.devel?
    p
  end

  def install
    ENV.enable_warnings # -w causes build to fail
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end

__END__
diff --git a/sysincludes.h b/sysincludes.h
index ee25556..8a57422 100644
--- a/sysincludes.h
+++ b/sysincludes.h
@@ -5,6 +5,10 @@
 #ifndef __sysincludes_h_included
 #define __sysincludes_h_included 1
 
+#if __APPLE__
+#define __APPLE_USE_RFC_3542 1
+#endif
+
 #if HAVE_LIMITS_H
 #include <limits.h>	/* USHRT_MAX */
 #endif
