require "formula"

# Linear (or longitudinal) Timecode (LTC) coder and decoder.

class Libltc < Formula
  homepage "http://x42.github.io/libltc/"
  url "https://github.com/x42/libltc/releases/download/v1.1.3/libltc-1.1.3.tar.gz"
  sha1 "7a5ed324c4a8f87ae1165d8484a153efce18f803"

# This patch has been fixed in the master branch not released yet (https://github.com/x42/libltc/commit/b98e5d4094fbbc637fc83fe25d8348e41c325cf8)
  patch :DATA

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

end

__END__
diff --git a/src/ltc.h b/src/ltc.h
index d465c4d..65aafaa 100644
--- a/src/ltc.h
+++ b/src/ltc.h
@@ -44,7 +44,7 @@
 # define LTC_BIG_ENDIAN
 #elif defined _BIG_ENDIAN
 # define LTC_BIG_ENDIAN
-#else
+#elif !defined __LITTLE_ENDIAN__
 # include <endian.h>
 # if __BYTE_ORDER__ ==  __ORDER_BIG_ENDIAN__
 #  define LTC_BIG_ENDIAN
