require 'formula'

class Hudson <Formula
  url 'http://updates.hudson-labs.org/download/war/1.395/hudson.war', :using => :nounzip
  version '1.395'
  md5 '6af0fb753a099616c74104c60d6b26dd'
  homepage 'http://hudson-ci.org'

  def install
    lib.install "hudson.war"
    (prefix+'org.hudson-ci.plist').write startup_plist
  end

  def caveats; <<-EOS
If this is your first install, automatically load on login with:
    cp #{prefix}/org.hudson-ci.plist ~/Library/LaunchAgents
    launchctl load -w ~/Library/LaunchAgents/org.hudson-ci.plist

If this is an upgrade and you already have the org.hudson-ci.plist loaded:
    launchctl unload -w ~/Library/LaunchAgents/org.hudson-ci.plist
    cp #{prefix}/org.hudson-ci.plist ~/Library/LaunchAgents
    launchctl load -w ~/Library/LaunchAgents/org.hudson-ci.plist

Or start it manually:
    java -jar #{lib}/hudson.war
EOS
  end

  def startup_plist
    return <<-EOS
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>Hudson</string>
    <key>ProgramArguments</key>
    <array>
    <string>/usr/bin/java</string>
    <string>-jar</string>
    <string>#{lib}/hudson.war</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
EOS
  end

end
