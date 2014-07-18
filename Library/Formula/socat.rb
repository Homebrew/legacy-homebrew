require 'formula'

class Socat < Formula
  homepage 'http://www.dest-unreach.org/socat/'
  url 'http://www.dest-unreach.org/socat/download/socat-1.7.2.2.tar.bz2'
  sha1 'ba270b85b0d16a6b300159f9b0d88653a9f5d9da'

  devel do
    url 'http://www.dest-unreach.org/socat/download/socat-2.0.0-b6.tar.bz2'
    sha1 '8873c8ab721bc301bfd5026872bace9e01e7bfac'
    patch :DATA
  end

  depends_on 'readline'

  # Socat devs are aware; see: https://trac.macports.org/ticket/32044
  patch :p0 do
    url "https://trac.macports.org/export/90442/trunk/dports/sysutils/socat/files/patch-xioexit.c.diff"
    sha1 "e555d20551f44cddc2613687ff31ec7f0ef09f79"
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
