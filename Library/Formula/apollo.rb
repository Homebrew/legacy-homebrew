require 'formula'

class Apollo < Formula
  homepage 'http://activemq.apache.org/apollo'
  url 'http://archive.apache.org/dist/activemq/activemq-apollo/1.7/apache-apollo-1.7-unix-distro.tar.gz'
  version '1.7'
  sha1 '3bf6dba6396fe3814e56163249de80d8a20230d0'

  option "no-bdb", "Install without bdb store support"
  option "no-mqtt", "Install without MQTT protocol support"

  # http://www.oracle.com/technetwork/database/berkeleydb/overview/index-093405.html
  resource 'bdb-je' do
    url 'http://download.oracle.com/maven/com/sleepycat/je/5.0.34/je-5.0.34.jar'
    sha1 '66db4f43ca0f462cd6b623be9e7a87180590b487'
  end

  # https://github.com/fusesource/fuse-extra/tree/master/fusemq-apollo/fusemq-apollo-mqtt
  resource 'mqtt' do
    url 'http://repo.fusesource.com/nexus/content/repositories/public/org/fusesource/fuse-extra/fusemq-apollo-mqtt/1.3/fusemq-apollo-mqtt-1.3-uber.jar'
    mirror 'http://repo1.maven.org/maven2/org/fusesource/fuse-extra/fusemq-apollo-mqtt/1.3/fusemq-apollo-mqtt-1.3-uber.jar'
    sha1 'a802a5675ec0d12bf596fb2d204c581bd6ae2ae1'
  end

  def install
    prefix.install_metafiles
    prefix.install %w{ docs examples }
    libexec.install Dir['*']

    (libexec/'lib').install resource('bdb-je') unless build.include? "no-bdb"
    (libexec/'lib').install resource('mqtt') unless build.include? "no-mqtt"

    bin.write_exec_script libexec/'bin/apollo'
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/var/apollo/bin/apollo-broker"

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
