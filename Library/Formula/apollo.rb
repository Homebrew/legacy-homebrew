require 'formula'

class BerkeleyDbJe < Formula
  homepage 'http://www.oracle.com/technetwork/database/berkeleydb/overview/index-093405.html'
  url "http://download.oracle.com/maven/com/sleepycat/je/5.0.34/je-5.0.34.jar"
  version '5.0.34'
  sha1 '66db4f43ca0f462cd6b623be9e7a87180590b487'
end

class FuseMQApolloMQTT < Formula
  homepage 'https://github.com/fusesource/fuse-extra/tree/master/fusemq-apollo/fusemq-apollo-mqtt'
  url "http://repo.fusesource.com/nexus/content/repositories/public/org/fusesource/fuse-extra/fusemq-apollo-mqtt/1.3/fusemq-apollo-mqtt-1.3-uber.jar"
  version '1.3'
  sha1 'a802a5675ec0d12bf596fb2d204c581bd6ae2ae1'
end

class Apollo < Formula
  homepage 'http://activemq.apache.org/apollo'
  url "http://archive.apache.org/dist/activemq/activemq-apollo/1.5/apache-apollo-1.5-unix-distro.tar.gz"
  version "1.5"
  sha1 '7944c4f40f2b98c79cd697a06238d056f7b4b394'

  option "no-bdb", "Install without bdb store support"
  option "no-mqtt", "Install without MQTT protocol support"

  def install
    prefix.install_metafiles
    prefix.install %w{ docs examples }
    libexec.install Dir['*']

    unless build.include? "no-bdb"
      BerkeleyDbJe.new.brew do
        (libexec+"lib").install Dir['*.jar']
      end
    end

    unless build.include? "no-mqtt"
      FuseMQApolloMQTT.new.brew do
        (libexec+"lib").install Dir['*.jar']
      end
    end

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
        <key>UserName</key>
        <string>#{`whoami`.chomp}</string>
        <key>WorkingDirectory</key>
        <string>#{var}/apollo</string>
      </dict>
    </plist>
    EOS
  end
end
