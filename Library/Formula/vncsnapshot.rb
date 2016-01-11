class Vncsnapshot < Formula
  desc "Command-line utility for taking VNC snapshots"
  homepage "https://sourceforge.net/projects/vncsnapshot/"
  url "https://downloads.sourceforge.net/project/vncsnapshot/vncsnapshot/1.2a/vncsnapshot-1.2a-src.tar.gz"
  sha256 "20f5bdf6939a0454bc3b41e87e41a5f247d7efd1445f4fac360e271ddbea14ee"

  bottle do
    cellar :any
    sha256 "2ac624dd5c2267341ea88187403020edef2256537bb76274e4a5e986df20ffd8" => :el_capitan
    sha256 "ccee01d747b767efa54eff88f366c26c996b8d0757b15a3beb57bb632f56f8b9" => :yosemite
    sha256 "fe6c35f85c2832241fa87595b1c55456a192a4620910fbc83d62447f00aaeaad" => :mavericks
  end

  depends_on "jpeg"

  patch :DATA # remove old PPC __APPLE__ ifdef from sockets.cxx

  def install
    # From Ubuntu
    inreplace "rfb.h" do |s|
      s.gsub! /typedef unsigned long CARD32;/, "typedef unsigned int CARD32;"
    end

    system "make"
    bin.install "vncsnapshot", "vncpasswd"
    man1.install "vncsnapshot.man1" => "vncsnapshot.1"
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
