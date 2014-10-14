require "formula"

class Mosquitto < Formula
  homepage "http://mosquitto.org/"
  url "http://mosquitto.org/files/source/mosquitto-1.3.4.tar.gz"
  sha1 "b818672cc0db723995d7c3201ef6962931dd891a"
  revision 1

  bottle do
    revision 1
    sha1 "5e8dfe80e2ea2af1af0e8ce3b79f59727b9ca82f" => :mavericks
    sha1 "1b11a70a2c1fe7d9edabc1e3c7419669afafbd6b" => :mountain_lion
    sha1 "1a36f985225e210c06d1e8d72ddaa7ab13c20337" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "c-ares"

  # mosquitto requires OpenSSL >=1.0 for TLS support
  depends_on "openssl"

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"

    # Create the working directory
    (var/"mosquitto").mkpath
  end

  test do
    quiet_system "#{sbin}/mosquitto", "-h"
    assert_equal 3, $?.exitstatus
  end

  def caveats; <<-EOD.undent
    mosquitto has been installed with a default configuration file.
    You can make changes to the configuration by editing:
        #{etc}/mosquitto/mosquitto.conf

    Python client bindings can be installed from the Python Package Index:
        pip install mosquitto

    Javascript client has been removed, see Eclipse Paho for an alternative.
    EOD
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
end
