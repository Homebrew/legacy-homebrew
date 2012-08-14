require 'formula'

class Fbida < Formula
  homepage 'http://linux.bytesex.org/fbida/'
  url 'http://dl.bytesex.org/releases/fbida/fbida-2.09.tar.gz'
  md5 '62415c7cb28d995f9d317868de0f2830'

  # Fix for build failure in fbida 2.09 (and earlier)
  # Check again in fbida 2.10
  def patches; DATA; end

  depends_on 'libexif'
  depends_on 'jpeg'

  def install
    ENV.append 'LDFLAGS', '-liconv'
    system "make"
    bin.install 'exiftran'
    man1.install 'exiftran.man' => 'exiftran.1'
  end
end

__END__
diff --git a/GNUmakefile b/GNUmakefile
index 2efae6c..af91be4 100644
--- a/GNUmakefile
+++ b/GNUmakefile
@@ -30,8 +30,8 @@ include $(srcdir)/mk/Autoconf.mk
 
 ac_jpeg_ver = $(shell \
 	$(call ac_init,for libjpeg version);\
-	$(call ac_s_cmd,echo -e '\#include <jpeglib.h>\nJPEG_LIB_VERSION' \
-		| cpp | tail -n 1);\
+	$(call ac_s_cmd,echo JPEG_LIB_VERSION \
+		| cpp -include jpeglib.h | tail -n 1);\
 	$(call ac_fini))
 
 define make-config
