require 'formula'

class Libgphoto2 < Formula
  homepage 'http://www.gphoto.org/proj/libgphoto2/'
  url 'http://downloads.sourceforge.net/project/gphoto/libgphoto/2.4.13/libgphoto2-2.4.13.tar.bz2'
  md5 'd20a32fe2bb7d802a6a8c3b6f7f97c5e'

  depends_on 'pkg-config' => :build
  depends_on 'libusb-compat'
  depends_on 'libexif' => :optional

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
  def patches
    if ARGV.include? '--patch'
      DATA
    end
  end
end

__END__
diff --git a/libgphoto2/gphoto2-list.c b/libgphoto2/gphoto2-list.c
index cc1b0ba..f6569ad 100644
--- a/libgphoto2/gphoto2-list.c
+++ b/libgphoto2/gphoto2-list.c
@@ -72,7 +72,7 @@
 
 #ifdef CAMERALIST_STRUCT_COMPATIBILITY
 
-#define MAX_ENTRIES 1024
+#define MAX_ENTRIES 2048
 #define MAX_LIST_STRING_LENGTH 128
 struct _CameraList {
        int  count;
