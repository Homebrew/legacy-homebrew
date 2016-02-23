class Mosquitto < Formula
  desc "Message broker implementing MQ telemetry transport protocol"
  homepage "https://mosquitto.org/"
  url "https://mosquitto.org/files/source/mosquitto-1.4.8.tar.gz"
  sha256 "d96eb5610e57cc3e273f4527d3f54358ab7711459941a9e64bc4d0a85c2acfda"

  bottle do
    sha256 "e675921d54e51a7cf9aca154d464cda5a65b64f9c68c18f5d028bc7305c0030c" => :el_capitan
    sha256 "c2639beb4f71fa7520a017c888b7008bf3c3046343ef742f651dfa671157a132" => :yosemite
    sha256 "5b86c30729f7d3fc6528564a8b92ac1765e50abb8b0fb59b6896bcf4505503f0" => :mavericks
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
  end

  def post_install
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
