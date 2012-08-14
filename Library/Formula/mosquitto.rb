require 'formula'

class Mosquitto < Formula
  homepage 'http://mosquitto.org/'
  url 'http://mosquitto.org/files/source/mosquitto-1.0.tar.gz'
  sha1 '5305bcf6e760f03eb60d5542303d153795915994'

  # mosquitto requires OpenSSL >=1.0 for TLS support
  depends_on 'openssl'
  depends_on 'cmake' => :build

  def patches
    [
      # fix TLS-PSK support in CMake build
      'https://bitbucket.org/oojah/mosquitto/changeset/c94726931053/raw/'
    ]
  end

  def install
    openssl = Formula.factory('openssl')

    # specify brew-supplied OpenSSL libraries and includes
    inreplace "CMakeLists.txt", "set (OPENSSL_INCLUDE_DIR \"\")", "set (OPENSSL_INCLUDE_DIR \"#{openssl.include}\")\nset (OPENSSL_LIBRARIES \"#{openssl.lib}\")"
    # this corrects the name of a man page
    inreplace "man/CMakeLists.txt", "install(FILES mosquitto-ssl.7 DESTINATION ${MANDIR}/man7)", "install(FILES mosquitto-tls.7 DESTINATION ${MANDIR}/man7)"

    system "cmake", ".", *std_cmake_args
    system "make install"

    plist_path.write startup_plist
    plist_path.chmod 0644
  end

  def test
    system "#{sbin}/mosquitto -h > /dev/null ; [ $? -eq 3 ]"
  end

  def caveats
    return <<-EOD.undent
    mosquitto has been installed with a default configuration file.
        Edit #{etc}/mosquitto/mosquitto.conf to make changes to the setup.

    If this is your first install, automatically load on login with:
        mkdir -p ~/Library/LaunchAgents
        cp #{plist_path} ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/#{plist_path.basename}

    If this is an upgrade and you already have the #{plist_path.basename} loaded:
        launchctl unload -w ~/Library/LaunchAgents/#{plist_path.basename}
        cp #{plist_path} ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/#{plist_path.basename}

    Start the broker manually by running:
        mosquitto
      EOD
  end

  def startup_plist
    return <<-EOS
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>#{plist_name}</string>
  <key>ProgramArguments</key>
  <array>
    <string>#{HOMEBREW_PREFIX}/sbin/mosquitto</string>
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
  <string>#{HOMEBREW_PREFIX}</string>
</dict>
</plist>
EOS
  end

end
