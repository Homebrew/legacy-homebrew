class Mosquitto < Formula
  desc "Message broker implementing MQ telemetry transport protocol"
  homepage "http://mosquitto.org/"
  url "http://mosquitto.org/files/source/mosquitto-1.4.5.tar.gz"
  sha256 "b432e19fee0c549f4a0fb0e866d1b6a897b38dbf1ddfda92bb43e2a24f01df66"

  bottle do
    sha256 "ee66a7033cad1d89c556b2a1d6923371613cc6ba70d7fba1ee61bb2bc32bc402" => :el_capitan
    sha256 "3a8c7180105e94d9fc579a272b5d0fffea7a33c19f39a844cf30d9b443fa19d3" => :yosemite
    sha256 "c2f1e914cd3bcff22f2d23fd2f381e0ece7f352f579f4f0c045976c84b829cdc" => :mavericks
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
