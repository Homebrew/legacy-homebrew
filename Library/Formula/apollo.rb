require 'formula'

class BerkeleyDbJe < Formula
  homepage 'http://www.oracle.com/technetwork/database/berkeleydb/overview/index-093405.html'
  url "http://download.oracle.com/maven/com/sleepycat/je/5.0.34/je-5.0.34.jar"
  version '5.0.34'
  md5 '09fa2cb8431bb4ca5a0a0f83d3d57ed0'
end

class FuseMQApolloMQTT < Formula
  homepage 'https://github.com/fusesource/fuse-extra/tree/master/fusemq-apollo/fusemq-apollo-mqtt'
  url "http://repo.fusesource.com/nexus/content/repositories/public/org/fusesource/fuse-extra/fusemq-apollo-mqtt/1.2/fusemq-apollo-mqtt-1.2-uber.jar"
  version '1.2'
  md5 '73ec840bdff182f4bbd8f9e8a60e4af4'
end

class Apollo < Formula
  homepage 'http://activemq.apache.org/apollo'
  url "http://archive.apache.org/dist/activemq/activemq-apollo/1.3/apache-apollo-1.3-unix-distro.tar.gz"
  version "1.3"
  md5 '13759c529b238731ebea269254a840b9'


  def options
    [
      ["--no-bdb", "Install without bdb store support."],
      ["--no-mqtt", "Install without MQTT protocol support."]
    ]
  end

  def install
    prefix.install %w{ LICENSE NOTICE readme.html docs examples }
    libexec.install Dir['*']

    unless ARGV.include? "--no-bdb"
      BerkeleyDbJe.new.brew do
        (libexec+"lib").install Dir['*.jar']
      end
    end

    unless ARGV.include? "--no-mqtt"
      FuseMQApolloMQTT.new.brew do
        (libexec+"lib").install Dir['*.jar']
      end
    end

    (bin+'apollo').write <<-EOS.undent
      #!/bin/bash
      exec "#{libexec}/bin/#{name}" "$@"
    EOS

    plist_path.write startup_plist
    plist_path.chmod 0644
  end

  def caveats; <<-EOS.undent
    To create the broker:
        #{bin}/apollo create #{var}/apollo

    If this is your first install, automatically load on login with:
        mkdir -p ~/Library/LaunchAgents
        cp #{plist_path} ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/#{plist_path.basename}

    If this is an upgrade and you already have the #{plist_path.basename} loaded:
        launchctl unload -w ~/Library/LaunchAgents/#{plist_path.basename}
        cp #{plist_path} ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/#{plist_path.basename}

    Or to start the broker in the foreground run:
        #{var}/apollo/bin/apollo-broker run

    EOS
  end

  def startup_plist; <<-EOS
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
    <key>UserName</key>
    <string>#{`whoami`.chomp}</string>
    <key>WorkingDirectory</key>
    <string>#{var}/apollo</string>
  </dict>
</plist>
EOS
  end

end
