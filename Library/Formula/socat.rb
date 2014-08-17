require 'formula'

class Socat < Formula
  homepage 'http://www.dest-unreach.org/socat/'
  url 'http://www.dest-unreach.org/socat/download/socat-1.7.2.4.tar.bz2'
  mirror 'http://ftp.de.debian.org/debian/pool/main/s/socat/socat_1.7.2.4.orig.tar.bz2'
  sha1 '55650f3c4c1a5cdc323b2e6eece416b6303d39b5'

  bottle do
    cellar :any
    sha1 "2adcb868d02085a1750ae6d2cb737a133f46e758" => :mavericks
    sha1 "7fbdafbdd205731de188c08f501816cf835ea9c8" => :mountain_lion
    sha1 "57e25b005e2f3261861400adf34869460daf828d" => :lion
  end

  devel do
    url 'http://www.dest-unreach.org/socat/download/socat-2.0.0-b7.tar.gz'
    mirror 'http://fossies.org/linux/privat/socat-2.0.0-b7.tar.gz'
    sha1 'b9ce176ab1ad974a0f01810b517d404214f40288'
    patch :DATA
  end

  depends_on 'readline'
  depends_on 'openssl'

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
