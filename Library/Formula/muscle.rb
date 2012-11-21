require 'formula'

class Muscle < Formula
  homepage 'http://www.drive5.com/muscle/'
  url 'http://www.drive5.com/muscle/downloads3.8.31/muscle3.8.31_src.tar.gz'
  version '3.8.31'
  sha1 '2fe55db73ff4e7ac6d4ca692f8f213d1c5071dac'

  # This patch makes 3.8.31 build on OSX >= Lion.
  # It has been reported upstream but not fixed yet.
  def patches
    DATA
  end

  def install
    cd "src" do
      system "make"
      bin.install "muscle"
    end
  end
end

__END__
--- a/src/globalsosx.cpp	2010-04-28 16:43:42.000000000 -0700
+++ b/src/globalsosx.cpp	2012-11-20 15:53:14.000000000 -0800
@@ -13,10 +13,10 @@
 #include <netinet/icmp6.h>
 #include <sys/vmmeter.h>
 #include <sys/proc.h>
+#include <mach/vm_statistics.h>
 #include <mach/task_info.h>
 #include <mach/task.h>
 #include <mach/mach_init.h>
-#include <mach/vm_statistics.h>
 
 const double DEFAULT_RAM = 1e9;
 const double DEFAULT_MEM_USE = 1e6;
