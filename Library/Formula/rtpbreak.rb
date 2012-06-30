require 'formula'

class Rtpbreak < Formula
  homepage 'http://www.dallachiesa.com/code/rtpbreak/doc/rtpbreak_en.html'
  url 'http://dallachiesa.com/code/rtpbreak/rtpbreak-1.3a.tgz'
  sha1 'd22e9c37cc28c2fc36475d221b4eb2cc2c5aafbb'

  depends_on 'libnet'

  def patches
    # main.c is missing the netinet/udp.h header; reported upstream by email
    {:p0 => DATA}
  end

  def install
    system "make", "CC=#{ENV.cc}"
    bin.install('src/rtpbreak')
  end

  def test
    system "rtpbreak"
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
