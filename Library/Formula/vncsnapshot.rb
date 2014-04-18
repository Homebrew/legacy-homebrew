require 'formula'

class Vncsnapshot < Formula
  homepage 'http://sourceforge.net/projects/vncsnapshot/'
  url 'https://downloads.sourceforge.net/project/vncsnapshot/vncsnapshot/1.2a/vncsnapshot-1.2a-src.tar.gz'
  sha1 '115d9497467e5e5f13df2c108893db3d1d4c51bc'

  depends_on 'jpeg'

  patch :DATA # remove old PPC __APPLE__ ifdef from sockets.cxx

  def install
    # From Ubuntu
    inreplace 'rfb.h' do |s|
      s.gsub! /typedef unsigned long CARD32;/, 'typedef unsigned int CARD32;'
    end

    system "make"
    bin.install 'vncsnapshot', 'vncpasswd'
    man1.install 'vncsnapshot.man1' => 'vncsnapshot.1'
  end
end

__END__
diff --git a/sockets.cxx b/sockets.cxx
index ecdf0db..6c827fa 100644
--- a/sockets.cxx
+++ b/sockets.cxx
@@ -38,9 +38,9 @@ typedef int socklen_t;
 #include <fcntl.h>
 #endif

-#ifdef __APPLE__
-typedef int socklen_t;
-#endif
+//#ifdef __APPLE__
+//typedef int socklen_t;
+//#endif

 extern "C" {
 #include "vncsnapshot.h"
