require 'formula'

class Ssldump <Formula
  url 'http://www.rtfm.com/ssldump/ssldump-0.9b3.tar.gz'
  homepage 'http://www.rtfm.com/ssldump/'
  md5 'ac8c28fe87508d6bfb06344ec496b1dd'

  def install
    ENV["LIBS"] = "-lssl -lcrypto"

    # .dylib, not .a
    inreplace "configure", "if test -f $dir/libpcap.a; then", "if test -f $dir/libpcap.dylib; then"

    system "./configure", "osx", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make"
    bin.install "ssldump"
    man1.install "ssldump.1"
  end

  def patches
    # reorder include files
    # => http://sourceforge.net/tracker/index.php?func=detail&aid=1622854&group_id=68993&atid=523055
    DATA
  end
end

__END__
--- a/base/pcap-snoop.c	2010-03-18 22:59:13.000000000 -0700
+++ b/base/pcap-snoop.c	2010-03-18 22:59:30.000000000 -0700
@@ -46,10 +46,9 @@
 
 static char *RCSSTRING="$Id: pcap-snoop.c,v 1.14 2002/09/09 21:02:58 ekr Exp $";
 
-
+#include <net/bpf.h>
 #include <pcap.h>
 #include <unistd.h>
-#include <net/bpf.h>
 #ifndef _WIN32
 #include <sys/param.h>
 #endif
