require 'formula'

class Graylog2Server < Formula
  url 'https://github.com/downloads/Graylog2/graylog2-server/graylog2-server-0.9.6.tar.gz'
  homepage 'http://www.graylog2.org/'
  md5 'c04257c0617555b8fec1580fbfa9ba5a'
  depends_on 'elasticsearch'
  depends_on 'mongodb'

  def install
    mv "graylog2.conf.example", "graylog2.conf"
    inreplace "graylog2.conf" do |s|
      # Better to use 127.0.0.1 instead of localhost so you
      # don't need to allow external access to MongoDB.
      # http://www.eimermusic.com/code/graylog2-on-mac-os-x/
      s.gsub! "mongodb_host = localhost", "mongodb_host = 127.0.0.1"
      s.gsub! "mongodb_useauth = true", "mongodb_useauth = false"
      s.gsub! "syslog_listen_port = 514", "syslog_listen_port = 8514"
    end

    inreplace "bin/graylog2ctl" do |s|
      s.gsub! "$NOHUP java -jar ../graylog2-server.jar &",
              "$NOHUP java -jar #{prefix}/graylog2-server.jar -f #{etc}/graylog2.conf -p /tmp/graylog2.pid &"
    end

    etc.install "graylog2.conf"
    prefix.install Dir['*']

    plist_path.write startup_plist
    plist_path.chmod 0644
  end

  def caveats
    <<-EOS.undent
      In the interest of allowing you to run graylog2-server as a
      non-root user, the default syslog_listen_port is set to 8514.

      If this is your first install, automatically load on login with:
          mkdir -p ~/Library/LaunchAgents
          cp #{plist_path} ~/Library/LaunchAgents/
          launchctl load -w ~/Library/LaunchAgents/#{plist_path.basename}

      If this is an upgrade and you already have the #{plist_path.basename} loaded:
          launchctl unload -w ~/Library/LaunchAgents/#{plist_path.basename}
          cp #{plist_path} ~/Library/LaunchAgents/
          launchctl load -w ~/Library/LaunchAgents/#{plist_path.basename}

      Or to manage graylog2-server without launchd:

        To start graylog2-server:
          graylog2ctl start

        To stop graylog2-server:
          graylog2ctl stop

        The config file is located at:
          #{etc}/graylog2.conf
    EOS
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
    <string>java</string>
    <string>-jar</string>
    <string>#{prefix}/graylog2-server.jar</string>
    <string>-f</string>
    <string>#{etc}/graylog2.conf</string>
    <string>-p</string>
    <string>/tmp/graylog2.pid</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
  <key>KeepAlive</key>
  <false/>
  <key>UserName</key>
  <string>#{`whoami`.chomp}</string>
  <key>WorkingDirectory</key>
  <string>#{HOMEBREW_PREFIX}</string>
  <key>StandardErrorPath</key>
  <string>#{var}/log/graylog2-server/error.log</string>
  <key>StandardOutPath</key>
  <string>#{var}/log/graylog2-server/output.log</string>
</dict>
</plist>
EOS
  end

  def test
    system "#{bin}/graylog2ctl"
  end
end
