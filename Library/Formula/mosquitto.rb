require "formula"

class Mosquitto < Formula
  homepage "http://mosquitto.org/"
  url "http://mosquitto.org/files/source/mosquitto-1.3.5.tar.gz"
  sha1 "2d30ffbf1c1b310581735e7ea10465e7c310e580"

  bottle do
    sha1 "85ed6685fb8efcf1aa909aaf50da8a843da819e0" => :yosemite
    sha1 "a505a2071a526c7eb18ce82ca9cd64022f1b0294" => :mavericks
    sha1 "a533fe55655eb71e3f104d36e52fecaaa1eb8ab0" => :mountain_lion
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
