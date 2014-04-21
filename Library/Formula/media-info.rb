require 'formula'

class MediaInfo < Formula
  homepage 'http://mediainfo.sourceforge.net'
  url 'http://mediaarea.net/download/binary/mediainfo/0.7.67/MediaInfo_CLI_0.7.67_GNU_FromSource.tar.bz2'
  version '0.7.67'
  sha1 'e5bfc3af8d3a0995785f1963c78ff9a6505e9626'

  # Fixed upstream, will be in next release
  # http://sourceforge.net/p/mediainfo/code/6167/
  patch :DATA

  depends_on 'pkg-config' => :build
  # fails to build against Leopard's older libcurl
  depends_on 'curl' if MacOS.version < :snow_leopard

  def install
    cd 'ZenLib/Project/GNU/Library' do
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}"
      system "make"
    end

    cd "MediaInfoLib/Project/GNU/Library" do
      args = ["--disable-debug",
              "--disable-dependency-tracking",
              "--with-libcurl",
              "--prefix=#{prefix}"]
      system "./configure", *args
      system "make install"
    end

    cd "MediaInfo/Project/GNU/CLI" do
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}"
      system "make install"
    end
  end
end

__END__
diff --git a/MediaInfoLib/Source/MediaInfo/Text/File_Ttml.h b/MediaInfoLib/Source/MediaInfo/Text/File_Ttml.h
index 554477c..46a4fec 100644
--- a/MediaInfoLib/Source/MediaInfo/Text/File_Ttml.h
+++ b/MediaInfoLib/Source/MediaInfo/Text/File_Ttml.h
@@ -19,8 +19,11 @@
 #include "MediaInfo/File__Analyze.h"
 //---------------------------------------------------------------------------
 
-class tinyxml2::XMLDocument;
-class tinyxml2::XMLElement;
+namespace tinyxml2
+{
+    class XMLDocument;
+    class XMLElement;
+}
 
 namespace MediaInfoLib
 {
