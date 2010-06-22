require 'formula'

class Ganglia <Formula
  url 'http://downloads.sourceforge.net/project/ganglia/ganglia%20monitoring%20core/3.1.7/ganglia-3.1.7.tar.gz'
  homepage 'http://ganglia.sourceforge.net/'
  md5 '6aa5e2109c2cc8007a6def0799cf1b4c'

  def patches
    # "kvm.h" was removed in OS X 10.5
    # Seems to build without the include, though.
    DATA
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--disable-python",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make install"
    man1.install Dir['mans/*']
  end
end


__END__
diff --git a/libmetrics/darwin/metrics.c b/libmetrics/darwin/metrics.c
index 498ed8f..66f9b2b 100644
--- a/libmetrics/darwin/metrics.c
+++ b/libmetrics/darwin/metrics.c
@@ -11,7 +11,7 @@
 
 #include <stdlib.h>
 #include "interface.h"
-#include <kvm.h>
+// #include <kvm.h>
 #include <sys/sysctl.h>
 
 #include <mach/mach_init.h>
