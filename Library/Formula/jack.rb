# This now builds a version of JACKv1 which matches the current API
# for JACKv2. JACKv2 is not buildable on a number of Mac OS X
# distributions, and the JACK team instead suggests installation of
# JACKOSX, a pre-built binary form for which the source is not available.
# If you require JACKv2, you should use that. Otherwise, this formula should
# operate fine.
# Please see https://github.com/Homebrew/homebrew/pull/22043 for more info
class Jack < Formula
  desc "Jack Audio Connection Kit (JACK)"
  homepage "http://jackaudio.org"
  url "http://jackaudio.org/downloads/jack-audio-connection-kit-0.124.1.tar.gz"
  sha256 "eb42df6065576f08feeeb60cb9355dce4eb53874534ad71534d7aa31bae561d6"

  bottle do
    revision 2
    sha256 "b4c1720c1e79b3d9a71cc79906175b90f6e30a8c2704c94e3c941d288b5453cc" => :el_capitan
    sha256 "9e793fc1460c67e5209365cdf524face6f66cb1da5ae706da36a6e6c616cfe16" => :yosemite
    sha256 "bed1d9c87b983abeb5ae57de0402707c6426c2426efee7be3c63c08948a5c5ec" => :mavericks
    sha256 "56f0c03a6293b616fbc5505d55b2a6ee20f8946f5789bdff005696892129017d" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "berkeley-db"
  depends_on "libsndfile"
  depends_on "libsamplerate"

  # Change pThread header include from CarbonCore
  patch :p0, :DATA if MacOS.version >= :mountain_lion

  plist_options :manual => "jackd -d coreaudio"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>WorkingDirectory</key>
      <string>#{prefix}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/jackd</string>
        <string>-d</string>
        <string>coreaudio</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <true/>
    </dict>
    </plist>
    EOS
  end

  def install
    # Makefile hardcodes Carbon header location
    inreplace Dir["drivers/coreaudio/Makefile.{am,in}"],
      "/System/Library/Frameworks/Carbon.framework/Headers/Carbon.h",
      "#{MacOS.sdk_path}/System/Library/Frameworks/Carbon.framework/Headers/Carbon.h"

    ENV["LINKFLAGS"] = ENV.ldflags
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
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
