require 'formula'

class SeleniumServerStandalone < Formula
  url 'http://selenium.googlecode.com/files/selenium-server-standalone-2.16.1.jar'
  homepage 'http://seleniumhq.org/'
  md5 'ce6e50d8c9114ffea5f712b93e088e5f'

  def install
    prefix.install "selenium-server-standalone-2.16.1.jar"
    (prefix + "selenium-server-standalone.plist").write plist_file
  end

  def caveats; <<-EOS
You can enable selenium-server to automatically load on login with:

  mkdir -p ~/Library/LaunchAgents
  cp "#{prefix}/selenium-server-standalone.plist" ~/Library/LaunchAgents/
  launchctl load -w ~/Library/LaunchAgents/selenium-server-standalone.plist

If this is an upgrade and you already have the selenium-server-standalone.plist loaded:

  launchctl unload -w ~/Library/LaunchAgents/selenium-server-standalone.plist
  cp #{prefix}/selenium-server-standalone.plist ~/Library/LaunchAgents/
  launchctl load -w ~/Library/LaunchAgents/selenium-server-standalone.plist

Or start it manually with:
  java -jar #{prefix}/selenium-server-standalone-2.16.1.jar -p 4444
EOS
  end

  def plist_file
    return <<-EOS
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
        <key>Label</key>
        <string>selenium-server-standalone</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <false/>
        <key>ProgramArguments</key>
        <array>
                <string>/usr/bin/java</string>
                <string>-jar</string>
                <string>#{prefix}/selenium-server-standalone-2.16.1.jar</string>
                <string>-port</string>
                <string>4444</string>
        </array>
        <key>ServiceDescription</key>
        <string>Selenium Server</string>
        <key>StandardErrorPath</key>
        <string>/var/log/selenium/selenium-error.log</string>
        <key>StandardOutPath</key>
        <string>/var/log/selenium/selenium-output.log</string>
</dict>
</plist>
    EOS
  end

end
