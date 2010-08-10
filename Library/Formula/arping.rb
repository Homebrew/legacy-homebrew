require 'formula'

class Arping <Formula
  url 'http://github.com/ThomasHabets/arping/tarball/arping-2.09'
  version '2.09'
  homepage 'http://github.com/ThomasHabets/arping'
  md5 '8a10b23655ffbe93667691fb881afbf4'

  depends_on 'libnet'

  def patches
    # Patch removes header conflict with libpcap; arping 2.x uses libnet
    DATA
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"

    # See patches comment
    inreplace 'Makefile' do |s|
      s.change_make_var! "LIBS", " -lnet"
    end

    system "make"
    system "make install"
  end
end

__END__
diff --git a/src/arping.c b/src/arping.c
index 7b5e43e..b80e4d8 100644
--- a/src/arping.c
+++ b/src/arping.c
@@ -78,12 +78,14 @@
 #if HAVE_WIN32_LIBNET_H
 #include <win32/libnet.h>
 #endif
-#include <pcap.h>
 
 #if HAVE_NET_BPF_H
 #include <net/bpf.h>
 #endif
 
+#define PCAP_DONT_INCLUDE_PCAP_BPF_H
+#include <pcap.h>
+
 #ifndef ETH_ALEN
 #define ETH_ALEN 6
 #endif

