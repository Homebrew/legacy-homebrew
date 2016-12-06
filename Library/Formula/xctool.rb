require 'formula'

class Xctool < Formula
  homepage 'https://github.com/facebook/xctool'
  url 'https://github.com/facebook/xctool/archive/v0.1.0.tar.gz'
  sha1 'f5cf21d14f26127cea6b6b069fcc2c7387c41af6'
  version '0.1.0'

  depends_on :xcode

  def install
    system './build.sh'
    bin.install 'build/Products/Release/xctool'
    libexec.install Dir['build/Products/Release/*.dylib']
    libexec.install 'build/Products/Release/mobile-installation-helper.app'
  end

  def patches
    # xctool needs to know where to find the dylibs and the mobile-installation-helper.app
    # and we don't want them in the bin directory
    DATA
  end
end

__END__
diff --git a/xctool/xctool/XCToolUtil.m b/xctool/xctool/XCToolUtil.m
index 384fb7b..c0097db 100644
--- a/xctool/xctool/XCToolUtil.m
+++ b/xctool/xctool/XCToolUtil.m
@@ -94,7 +94,10 @@ NSString *PathToXCToolBinaries(void)
     // build products.
     return [NSProcessInfo processInfo].environment[@"DYLD_LIBRARY_PATH"];
   } else {
-    return [AbsoluteExecutablePath() stringByDeletingLastPathComponent];
+    NSString *libexecPath = [[[AbsoluteExecutablePath() stringByDeletingLastPathComponent]
+                              stringByDeletingLastPathComponent]
+                             stringByAppendingPathComponent:@"libexec"];
+    return libexecPath;
   }
 }
