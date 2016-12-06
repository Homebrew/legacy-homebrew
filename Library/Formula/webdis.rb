require 'formula'

class Webdis < Formula
  head 'git://github.com/nicolasff/webdis.git'
  homepage 'http://webd.is/'

  depends_on 'libevent'

  def install
    system "make clean all"
    bin.install "webdis"

    inreplace "webdis.json" do |s|
      s.gsub! '"logfile": "webdis.log"', "\"logfile\": \"#{var}/log/webdis.log\""
    end

    etc.install "webdis.json"
    (prefix+'is.webd.webdis.plist').write startup_plist
  end

  def caveats
    <<-EOS.undent
    If this is your first install, automatically load on login with:
        mkdir -p ~/Library/LaunchAgents
        cp #{prefix}/is.webd.webdis.plist ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/is.webd.webdis.plist
    If this is an upgrade and you already have the is.webd.webdis.plist loaded:
        launchctl unload -w ~/Library/LaunchAgents/is.webd.webdis.plist
        cp #{prefix}/is.webd.webdis.plist ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/is.webd.webdis.plist

      To start webdis manually:
        webdis #{etc}/webdis.json
    EOS
  end

  def startup_plist
    return <<-EOPLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>KeepAlive</key>
    <true/>
    <key>Label</key>
    <string>is.webd.webdis</string>
    <key>ProgramArguments</key>
    <array>
      <string>#{bin}/webdis</string>
      <string>#{etc}/webdis.json</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>UserName</key>
    <string>#{`whoami`.chomp}</string>
    <key>WorkingDirectory</key>
    <string>#{var}</string>
    <key>StandardErrorPath</key>
    <string>#{var}/log/webdis.log</string>
    <key>StandardOutPath</key>
    <string>#{var}/log/webdis.log</string>
  </dict>
</plist>
    EOPLIST
  end
end
