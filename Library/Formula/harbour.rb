require "formula"

class Harbour < Formula
  homepage "https://harbour.github.io"
  url "https://downloads.sourceforge.net/harbour-project/source/3.0.0/harbour-3.0.0.tar.bz2"
  sha1 "66c21d666ac24c45485179eeaa9f90458b552e92"

  bottle do
    cellar :any
    sha1 "ff777eb55a1f944d7dd1bcc4e07506996e60af0e" => :mavericks
    sha1 "bfc3a646867b5176dad976c4e0f6c40c7a4a7417" => :mountain_lion
    sha1 "0127b7daaaae6393fd69fff8e7e21a9ebae7c18d" => :lion
  end

  head "https://github.com/harbour/core.git"

  depends_on "pcre"
  depends_on :x11 => :recommended

  # Missing a header that was deprecated by libcurl @ version 7.12.0 and
  # deleted sometime after Harbour 3.0.0 release.
  stable do
    patch :DATA
  end

  def install
    ENV["HB_INSTALL_PREFIX"] = prefix
    ENV["HB_WITH_X11"] = "no" if build.without? "x11"

    ENV.deparallelize

    system "make", "install"

    rm Dir[bin/"hbmk2.*.hbl"]
    rm bin/"contrib.hbr" if build.head?
    rm bin/"harbour.ucf" if build.head?
  end

  test do
    (testpath/"hello_world.prg").write("procedure Main();?'Hello, world!';?;?OS();?Version();return")
    system "#{bin}/hbmk2", "-run", "hello_world.prg"
  end
end

__END__
diff --git a/contrib/hbcurl/core.c b/contrib/hbcurl/core.c
index 00caaa8..53618ed 100644
--- a/contrib/hbcurl/core.c
+++ b/contrib/hbcurl/core.c
@@ -53,8 +53,12 @@
  */

 #include <curl/curl.h>
-#include <curl/types.h>
-#include <curl/easy.h>
+#if LIBCURL_VERSION_NUM < 0x070A03
+#  include <curl/easy.h>
+#endif
+#if LIBCURL_VERSION_NUM < 0x070C00
+#  include <curl/types.h>
+#endif

 #include "hbapi.h"
 #include "hbapiitm.h"
