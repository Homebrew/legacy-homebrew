require "formula"

class Mosquitto < Formula
  homepage "http://mosquitto.org/"
  url "http://mosquitto.org/files/source/mosquitto-1.3.1.tar.gz"
  sha1 "dcba02c12dffa27a0e76e68f88de21fb5f7de29d"
  revision 1

  bottle do
    sha1 "72a9d7a8fe725804d1d1b802e598c7ce54e1871b" => :mavericks
    sha1 "1f97f45bb8937ecde69eb5d3cdca065843be86e8" => :mountain_lion
    sha1 "8f39cbe81f2c7f3a0df82baaf9dcca8ebb1ff238" => :lion
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
