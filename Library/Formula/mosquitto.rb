require 'formula'

class Mosquitto < Formula
  homepage 'http://mosquitto.org/'
  url 'http://mosquitto.org/files/source/mosquitto-1.0.1.tar.gz'
  sha1 'f676c07885d3f76745acddce9f73ae395758ffc7'

  # mosquitto requires OpenSSL >=1.0 for TLS support
  depends_on 'openssl' => :build
  # without pkg-config there can be errors with incorrect arch libraries for OpenSSL
  depends_on 'pkg-config' => :build
  depends_on 'cmake' => :build

  def options
    [
      ["--with-python", "Build and install Python bindings (alternative to pip install mosquitt"],
    ]
  end

  def install
    openssl = Formula.factory('openssl')

    # specify brew-supplied OpenSSL libraries and includes
    inreplace "CMakeLists.txt", "set (OPENSSL_INCLUDE_DIR \"\")", "set (OPENSSL_INCLUDE_DIR \"#{openssl.include}\")\nset (OPENSSL_LIBRARIES \"#{openssl.lib}\")"

    system "cmake", ".", *std_cmake_args
    system "make install"

    # Install Python bindings (optional - since also available via pypi)
    cd "lib/python" do
      system "python", "setup.py", "build"
      system "python", "setup.py", "install", "--prefix=#{prefix}"
    end if ARGV.include? "--with-python"

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
        mosquitto -c #{etc}/mosquitto/mosquitto.conf

    Python client bindings may also be installed from the Python Package Index via
        pip install mosquitto

    Javascript client is available via
        http://mosquitto.org/js/
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
