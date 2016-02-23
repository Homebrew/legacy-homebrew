class ArgyllCms < Formula
  desc "ICC compatible color management system"
  homepage "http://www.argyllcms.com/"
  url "http://www.argyllcms.com/Argyll_V1.8.3_src.zip"
  version "1.8.3"
  sha256 "60494176785f6c2e4e4daefb9452d83859880449040b2a843ed81de3bd0c558e"

  bottle do
    cellar :any
    sha256 "f9273d28a71e29744da63c9893f5d6d4df317de0202933e7a2d60906d1176e82" => :el_capitan
    sha256 "156f0bc1514107128bdb97161a75e9a095494fec3c8fe1095892abc2e0dd9aad" => :yosemite
    sha256 "f7b3b3ff9a8ce27e274380525fd401e8a48788eadc8e063a4fd00868a0674394" => :mavericks
  end

  depends_on "jam" => :build
  depends_on "jpeg"
  depends_on "libtiff"

  conflicts_with "num-utils", :because => "both install `average` binaries"

  patch :DATA

  def install
    system "sh", "makeall.sh"
    system "./makeinstall.sh"
    rm "bin/License.txt"
    prefix.install "bin", "ref", "doc"
  end

  test do
    system bin/"targen", "-d", "0", "test.ti1"
    system bin/"printtarg", testpath/"test.ti1"
    %w[test.ti1.ps test.ti1.ti1 test.ti1.ti2].each { |f| File.exist? f }
  end
end

__END__
diff --git a/spectro/dispwin.c b/spectro/dispwin.c
index fffbaee..18343db 100755
--- a/spectro/dispwin.c
+++ b/spectro/dispwin.c
@@ -113,7 +113,7 @@ typedef float CGFloat;
 #endif
 #endif	/* !NSINTEGER_DEFINED */
 
-#include <IOKit/Graphics/IOGraphicsLib.h>
+#include <IOKit/graphics/IOGraphicsLib.h>
 
 #if __MAC_OS_X_VERSION_MAX_ALLOWED <= 1060
 /* This wasn't declared in 10.6, although it is needed */
