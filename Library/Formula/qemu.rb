require 'formula'

class Qemu < Formula
  url 'http://wiki.qemu.org/download/qemu-1.0.tar.gz'
  homepage 'http://www.qemu.org/'
  md5 'a64b36067a191451323b0d34ebb44954'

  depends_on 'jpeg'
  depends_on 'gnutls'
  depends_on 'glib'
 
  def patches
    #original patch from http://patchwork.ozlabs.org/patch/123112/
    #first attempt by https://github.com/joaohenriques
    #fix by https://github.com/rcarmo
    DATA
  end
  
  def install
    system "./configure", "--prefix=#{prefix}",
                          "--cc=gcc-4.2",          # essential for running on Lion
                          "--host-cc=gcc-4.2",     # ditto
                          "--enable-cocoa",        # nice Cocoa UI
                          "--disable-darwin-user", # current workarounds for broken modules on OSX
                          "--disable-bsd-user",    # ditto
                          "--disable-guest-agent",  
                          "--audio-drv-list=coreaudio",
                          "--audio-card-list=ac97,adlib,sb16" # niceties fror game emulation
    system "make install"
  end
end
__END__
diff --git a/fpu/softfloat.h b/fpu/softfloat.h
index 07c2929..229d834 100644
--- a/fpu/softfloat.h
+++ b/fpu/softfloat.h
@@ -57,7 +57,7 @@ typedef uint8_t flag;
 typedef uint8_t uint8;
 typedef int8_t int8;
 #ifndef _AIX
-typedef int uint16;
+typedef uint16_t uint16;
-typedef int int16;
+typedef int16_t int16;
 #endif
 typedef unsigned int uint32;
