class Mosquitto < Formula
  desc "Message broker implementing MQ telemetry transport protocol"
  homepage "http://mosquitto.org/"
  url "http://mosquitto.org/files/source/mosquitto-1.4.2.tar.gz"
  sha256 "5ebc3800a0018bfbec62dcc3748fb29f628df068acd39c62c4ef651d9276647e"

  bottle do
    sha256 "b562825f6e1df8ecae423c52414a0be3a7c53ecb2085bca81b22d7df069ee804" => :el_capitan
    sha256 "5ddaaa8d6a3b1243e56a401352a30c98baac64912d727db4f1d863c91cde49d5" => :yosemite
    sha256 "ebf06abb4e01eb008cc77ae09ae3ab2d593d4150398ebe5d25e0a08b0c80f4e5" => :mavericks
    sha256 "120219f9750c23bc66635222c9f79a4434188fbdb046a5a43b8d1d350eb62bde" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "c-ares"
  depends_on "libwebsockets" => :recommended

  # mosquitto requires OpenSSL >=1.0 for TLS support
  depends_on "openssl"

  def install
    args = std_cmake_args
    args << "-DWITH_WEBSOCKETS=ON" if build.with? "libwebsockets"

    system "cmake", ".", *args
    system "make", "install"

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
