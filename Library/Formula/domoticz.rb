class DomoticzDownloadStrategy < SubversionDownloadStrategy
  def stage
    cp_r "#{cached_location}/.", Dir.pwd
  end
end

class Domoticz < Formula
  homepage "http://www.domoticz.com/"
  head "http://svn.code.sf.net/p/domoticz/code/trunk/", :using => DomoticzDownloadStrategy

  depends_on "cmake" => :build
  depends_on "boost" => :build
  depends_on "openssl"
  depends_on "libusb"
  depends_on "libusb-compat"
  depends_on "homebrew/dupes/zlib"

  def install
    system "sed", "-i", "-e", "s:DESTINATION\\ /opt/domoticz:DESTINATION\\ \\$\\{CMAKE_INSTALL_PREFIX\\}/opt/domoticz:", "CMakeLists.txt"
    system "cmake", "-DCMAKE_BUILD_TYPE=Release", "-DCMAKE_INSTALL_PREFIX=#{prefix}", "CMakeLists.txt"
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
end
