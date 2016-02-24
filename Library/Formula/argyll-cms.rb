class ArgyllCms < Formula
  desc "ICC compatible color management system"
  homepage "http://www.argyllcms.com/"
  url "http://www.argyllcms.com/Argyll_V1.8.3_src.zip"
  version "1.8.3"
  sha256 "60494176785f6c2e4e4daefb9452d83859880449040b2a843ed81de3bd0c558e"

  bottle do
    cellar :any
    revision 1
    sha256 "4598c3c991524acfb49162ec6d7e28bba2e10e07c7a1515ea43da30d66eb3cc7" => :el_capitan
    sha256 "149da3dc3ff1634c599cafbc5e3bdc0610dbe01ccda97b191c6eca4bf9059987" => :yosemite
    sha256 "bfacf495413da04c187e2c40049b9a0d77f09df34dee8820a67624d449276b52" => :mavericks
  end

  depends_on "jam" => :build
  depends_on "jpeg"
  depends_on "libtiff"

  conflicts_with "num-utils", :because => "both install `average` binaries"

  # Fix build on case-sensitive filesystems.
  # Submitted to graeme@argyllcms.com on 23rd Feb 2016.
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
