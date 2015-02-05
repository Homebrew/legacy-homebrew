class Rtpbreak < Formula
  # Homepage and URL dead since at least Feb 2015
  homepage "http://www.dallachiesa.com/code/rtpbreak/doc/rtpbreak_en.html"
  url "http://dallachiesa.com/code/rtpbreak/rtpbreak-1.3a.tgz"
  mirror "https://raw.githubusercontent.com/DomT4/LibreMirror/master/Rtpbreak/rtpbreak-1.3a.tgz"
  sha1 "d22e9c37cc28c2fc36475d221b4eb2cc2c5aafbb"

  depends_on "libnet"

  # main.c is missing the netinet/udp.h header; reported upstream by email
  patch :p0, :DATA

  def install
    mkdir_p bin
    system "make", "CC=#{ENV.cc}"
    system "make", "install", "INSTALL_DIR=#{bin}"
  end

  test do
    assert_match /payload/, shell_output("#{bin}/rtpbreak -k")
  end
end

__END__

--- src/main.c  2012-06-30 12:22:29.000000000 +0200
+++ src/main.c  2012-06-30 12:19:11.000000000 +0200
@@ -25,6 +25,7 @@
 
 #include <time.h>
 #include <sys/stat.h>
+#include <netinet/udp.h>
 #include <pwd.h>
 #include <grp.h>
 #include "queue.h"
