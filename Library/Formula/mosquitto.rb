require 'formula'

class Mosquitto < Formula
  homepage 'http://mosquitto.org/'
  url 'http://mosquitto.org/files/source/mosquitto-1.1.3.tar.gz'
  sha1 '38faf05f696b6a8183c6f5e06fdba78ffb632316'

  depends_on 'pkg-config' => :build
  depends_on 'cmake' => :build
  # mosquitto requires OpenSSL >=1.0 for TLS support
  depends_on 'openssl'

  def install
    openssl = Formula.factory('openssl')

    # specify brew-supplied OpenSSL libraries and includes
    inreplace "CMakeLists.txt", "set (OPENSSL_INCLUDE_DIR \"\")", "set (OPENSSL_INCLUDE_DIR \"#{openssl.include}\")\nset (OPENSSL_LIBRARIES \"#{openssl.lib}\")"

    system "cmake", ".", *std_cmake_args
    system "make install"

    # Create the working directory under var
    (var+'mosquitto').mkpath
  end

  def test
    system "#{sbin}/mosquitto -h > /dev/null ; [ $? -eq 3 ]"
  end

  def caveats
    return <<-EOD.undent
    mosquitto has been installed with a default configuration file.
        You can make changes to the configuration by editing
        #{etc}/mosquitto/mosquitto.conf

    Python client bindings can be installed from the Python Package Index
        pip install mosquitto

    Javascript client is available at
        http://mosquitto.org/js/
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
        <string>#{opt_prefix}/sbin/mosquitto</string>
        <string>-c</string>
        <string>#{etc}/mosquitto/mosquitto.conf</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <false/>
      <key>UserName</key>
      <string>#{`whoami`.chomp}</string>
      <key>WorkingDirectory</key>
      <string>#{var}/mosquitto</string>
    </dict>
    </plist>
    EOS
  end
end
