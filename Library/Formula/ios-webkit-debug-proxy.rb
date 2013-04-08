require 'formula'

class LionOrNewer < Requirement
  fatal true

  satisfy MacOS.version >= :lion

  def message
    "ios-webkit-debug-proxy requires Mac OS X 10.7 (Lion) or newer."
  end
end

class IosWebkitDebugProxy < Formula
  homepage 'https://github.com/google/ios-webkit-debug-proxy'
  url 'https://github.com/google/ios-webkit-debug-proxy/archive/1.0.tar.gz'
  sha1 '2f05bdca351cb7730552a63b3825db858bf8fdd6'

  depends_on LionOrNewer
  depends_on :autoconf => :build
  depends_on :automake => :build
  depends_on 'libplist'
  depends_on 'usbmuxd'
  depends_on 'libimobiledevice'

  # Patch from upstream to fix compiling with clang
  # Can be removed in next release.
  def patches; DATA; end

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
diff --git a/src/ios_webkit_debug_proxy_main.c b/src/ios_webkit_debug_proxy_main.c
index e2f8f3c..c65180c 100644
--- a/src/ios_webkit_debug_proxy_main.c
+++ b/src/ios_webkit_debug_proxy_main.c
@@ -52,7 +52,7 @@ int main(int argc, char** argv) {
   int ret = iwdpm_configure(self, argc, argv);
   if (ret) {
     exit(ret > 0 ? ret : 0);
-    return;
+    return ret;
   }
 
   iwdpm_create_bridge(self);
