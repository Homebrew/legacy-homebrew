require 'formula'

class Qemu < Formula
  url 'http://wiki.qemu.org/download/qemu-1.0.tar.gz'
  homepage 'http://www.qemu.org/'
  md5 'a64b36067a191451323b0d34ebb44954'

  depends_on 'jpeg'
  depends_on 'gnutls'
  depends_on 'glib'
 
  fails_with_llvm "Segmentation faults occur at run-time with LLVM"

  def patches
    #patch from http://patchwork.ozlabs.org/patch/123112/
    DATA
  end
  
  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-cocoa",
                          "--disable-darwin-user",
                          "--enable-cocoa",
                     "--disable-bsd-user",
 	                  "--disable-guest-agent"
    system "make install"
  end
end
__END__
diff --git a/fpu/softfloat.h b/fpu/softfloat.h
index 07c2929..229d834 100644
--- a/fpu/softfloat.h
+++ b/fpu/softfloat.h
@@ -57,7 +57,9 @@ typedef uint8_t flag;
 typedef uint8_t uint8;
 typedef int8_t int8;
 #ifndef _AIX
+#if !(defined(__APPLE__) && defined(_UINT16))
 typedef int uint16;
+#endif
 typedef int int16;
 #endif
 typedef unsigned int uint32;
