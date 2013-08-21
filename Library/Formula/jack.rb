require 'formula'

# This now builds a version of JACKv1 which matches the current API
# for JACKv2. JACKv2 is not buildable on a number of Mac OS X
# distributions, and the JACK team instead suggests installation of
# JACKOSX, a pre-built binary form for which the source is not available.
# If you require JACKv2, you should use that. Otherwise, this formula should
# operate fine.
# Please see https://github.com/mxcl/homebrew/pull/22043 for more info
class Jack < Formula
  homepage 'http://jackaudio.org'
  url 'http://jackaudio.org/downloads/jack-audio-connection-kit-0.121.3.tar.gz'
  sha1 '7d6e2219660222d1512ee704dd88a534b3e3089e'

  depends_on 'celt'
  depends_on 'libsndfile'
  depends_on 'libsamplerate'

  def patches
    #Change pThread header include from CarbonCore
    { :p0 => DATA }
  end if MacOS.version >= :mountain_lion

  def install
    ENV['LINKFLAGS'] = ENV.ldflags
    system "./configure", "--prefix=#{prefix}"
    system "make","install"
  end
end

__END__
--- config/os/macosx/pThreadUtilities.h
+++ config/os/macosx/pThreadUtilities.h
@@ -66,7 +66,7 @@
 #define __PTHREADUTILITIES_H__
 
 #import "pthread.h"
-#import <CoreServices/../Frameworks/CarbonCore.framework/Headers/MacTypes.h>
+#import <MacTypes.h>
 
 #define THREAD_SET_PRIORITY      0
 #define THREAD_SCHEDULED_PRIORITY    1
