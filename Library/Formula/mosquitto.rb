class Mosquitto < Formula
  desc "Message broker implementing MQ telemetry transport protocol"
  homepage "http://mosquitto.org/"
  url "http://mosquitto.org/files/source/mosquitto-1.4.5.tar.gz"
  sha256 "b432e19fee0c549f4a0fb0e866d1b6a897b38dbf1ddfda92bb43e2a24f01df66"

  bottle do
    sha256 "0528c41e9742a6aa24002693abab3d70876321b0595da2e1bafbfc5037fc2eec" => :el_capitan
    sha256 "3cce415b8e13bef7982aa9d315141a144ce387c6de6b679c77bdffd583d1eff9" => :yosemite
    sha256 "94051cecaa4a6e4e101384d286837f4cae45f5cb12c606ef2c6730a24d724224" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "c-ares"
  depends_on "openssl"
  depends_on "libwebsockets" => :recommended

  def install
    args = std_cmake_args
    args << "-DWITH_WEBSOCKETS=ON" if build.with? "libwebsockets"

    system "cmake", ".", *args
    system "make", "install"

    # Create the working directory
    (var/"mosquitto").mkpath
  end

  def caveats; <<-EOS.undent
    mosquitto has been installed with a default configuration file.
    You can make changes to the configuration by editing:
        #{etc}/mosquitto/mosquitto.conf
    EOS
  end

  plist_options :manual => "mosquitto -c #{HOMEBREW_PREFIX}/etc/mosquitto/mosquitto.conf"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_sbin}/mosquitto</string>
        <string>-c</string>
        <string>#{etc}/mosquitto/mosquitto.conf</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <false/>
      <key>WorkingDirectory</key>
      <string>#{var}/mosquitto</string>
    </dict>
    </plist>
    EOS
  end

  test do
    quiet_system "#{sbin}/mosquitto", "-h"
    assert_equal 3, $?.exitstatus
  end
end
