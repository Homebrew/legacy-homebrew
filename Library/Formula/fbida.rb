class Fbida < Formula
  desc "View and edit photo images"
  homepage "http://linux.bytesex.org/fbida/"
  url "http://dl.bytesex.org/releases/fbida/fbida-2.10.tar.gz"
  sha256 "7a5a3aac61b40a6a2bbf716d270a46e2f8e8d5c97e314e927d41398a4d0b6cb6"

  bottle do
    cellar :any
    sha256 "9d5593851f4e1a378e96219288893de00fb3aaf3b8e454362d8d4c3568bcb694" => :yosemite
    sha256 "f0c80275d3c79df13d562c200fe2cc53474c9893ceff33686196efd0cc5dd286" => :mavericks
    sha256 "7f99cfe93aa20461e91af71cba12f362ecedf72410605775914d3a9173a7b7d2" => :mountain_lion
  end

  depends_on "libexif"
  depends_on "jpeg"

  # Fix issue in detection of jpeg library
  patch :DATA

  def install
    ENV.append "LDFLAGS", "-liconv"
    system "make"
    bin.install "exiftran"
    man1.install "exiftran.man" => "exiftran.1"
  end

  test do
    system "#{bin}/exiftran", "-9", "-o", "out.jpg", test_fixtures("test.jpg")
  end
end

__END__
diff --git a/GNUmakefile b/GNUmakefile
index 2d18ab4..5b409fb 100644
--- a/GNUmakefile
+++ b/GNUmakefile
@@ -30,7 +30,7 @@ include $(srcdir)/mk/Autoconf.mk
 
 ac_jpeg_ver = $(shell \
 	$(call ac_init,for libjpeg version);\
-	$(call ac_s_cmd,echo JPEG_LIB_VERSION \
+	$(call ac_s_cmd,printf JPEG_LIB_VERSION \
		| cpp -include jpeglib.h | tail -n 1);\
 	$(call ac_fini))
 
