class Apollo < Formula
  desc "Multi-protocol messaging broker based on ActiveMQ"
  homepage "https://activemq.apache.org/apollo"
  url "https://archive.apache.org/dist/activemq/activemq-apollo/1.7.1/apache-apollo-1.7.1-unix-distro.tar.gz"
  version "1.7.1"
  sha256 "74577339a1843995a5128d14c68b21fb8f229d80d8ce1341dd3134f250ab689d"

  option "no-bdb", "Install without bdb store support"
  option "no-mqtt", "Install without MQTT protocol support"

  # http://www.oracle.com/technetwork/database/berkeleydb/overview/index-093405.html
  resource "bdb-je" do
    url "http://download.oracle.com/maven/com/sleepycat/je/5.0.34/je-5.0.34.jar"
    sha256 "025afa4954ed4e6f926af6e9015aa109528b0f947fcb3790b7bace639fe558fa"
  end

  # https://github.com/fusesource/fuse-extra/tree/master/fusemq-apollo/fusemq-apollo-mqtt
  resource "mqtt" do
    url "http://repo.fusesource.com/nexus/content/repositories/public/org/fusesource/fuse-extra/fusemq-apollo-mqtt/1.3/fusemq-apollo-mqtt-1.3-uber.jar"
    mirror "http://repo1.maven.org/maven2/org/fusesource/fuse-extra/fusemq-apollo-mqtt/1.3/fusemq-apollo-mqtt-1.3-uber.jar"
    sha256 "2795caacbc6086c7de46b588d11a78edbf8272acb7d9da3fb329cb34fcb8783f"
  end

  def install
    prefix.install_metafiles
    prefix.install %w[docs examples]
    libexec.install Dir["*"]

    (libexec/"lib").install resource("bdb-je") unless build.include? "no-bdb"
    (libexec/"lib").install resource("mqtt") unless build.include? "no-mqtt"

    bin.write_exec_script libexec/"bin/apollo"
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/var/apollo/bin/apollo-broker run"

  def caveats; <<-EOS.undent
    To create the broker:
        #{bin}/apollo create #{var}/apollo
    EOS
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{var}/apollo/bin/apollo-broker</string>
          <string>run</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}/apollo</string>
      </dict>
    </plist>
    EOS
  end
end
