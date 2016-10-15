class DomoticzDownloadStrategy < SubversionDownloadStrategy
  def stage
    # Domoticz' build uses the svn revision for its version.
    # Thus rather than the default behavior of exporting the working copy
    # we must copy it including .svn folders.
    cp_r "#{cached_location}/.", Dir.pwd
  end
end

class Domoticz < Formula
  homepage "http://www.domoticz.com/"
  head "http://svn.code.sf.net/p/domoticz/code/trunk/", :using => DomoticzDownloadStrategy

  depends_on "cmake" => :build
  depends_on "boost" => :build # domoticz statically links boost
  depends_on "openssl"
  depends_on "libusb"
  depends_on "libusb-compat"

  def install
    # ensure to install files within the Cellar; an issue to include this is
    # filed upstream: http://www.domoticz.com/forum/tracker.php?p=1&t=420
    inreplace "CMakeLists.txt", %r{DESTINATION /opt/domoticz}, "DESTINATION ${CMAKE_INSTALL_PREFIX}/opt/domoticz"
    system "cmake", *std_cmake_args
    system "make"
    system "make", "install"
  end

  plist_options :manual => "com.domoticz.server"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Disabled</key>
      <false/>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{prefix}/opt/domoticz/domoticz</string>
        <string>-www</string>
        <string>8083</string>
        <string>-log</string>
        <string>/var/log/domoticz.log</string>
        <string>-loglevel</string>
        <string>0</string>
      </array>
      <key>OnDemand</key>
      <false/>
      <key>KeepAlive</key>
      <true/>
      <key>RunAtLoad</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{prefix}/opt/domoticz</string>
    </dict>
    </plist>
    EOS
  end

  test do
    system "#{prefix}/opt/domoticz/domoticz", "-h"
  end
end
