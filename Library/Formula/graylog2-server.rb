require 'formula'

class Graylog2Server < Formula
  homepage 'http://www.graylog2.org/'
  url 'http://download.graylog2.org/graylog2-server/graylog2-server-0.11.0.tar.gz'
  sha1 '03c94ce8f255a486d13b38c9ebad159588b30bef'

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
  end

  def caveats; <<-EOS.undent
      In the interest of allowing you to run graylog2-server as a
      non-root user, the default syslog_listen_port is set to 8514.

      The config file is located at:
        #{etc}/graylog2.conf
    EOS
  end

  plist_options :manual => "graylog2ctl start"

  def plist; <<-EOS.undent
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
        <string>#{opt_prefix}/graylog2-server.jar</string>
        <string>-f</string>
        <string>#{etc}/graylog2.conf</string>
        <string>-p</string>
        <string>/tmp/graylog2.pid</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <true/>
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

  test do
    system "#{bin}/graylog2ctl"
  end
end
