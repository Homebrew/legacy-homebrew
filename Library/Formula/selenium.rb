require 'formula'

class Selenium < Formula
  url 'http://selenium.googlecode.com/files/selenium-server-2.5.0.zip'
  homepage 'http://code.google.com/p/selenium/'
  sha1 '1d05579166a745354d05f7b6feb850edf76fc7d4'

  def install
    prefix.install "selenium-server-standalone-2.5.0.jar"
    (prefix+"log").mkpath
    (prefix+'org.nhabit.Selenium.plist').write startup_plist
  end

  def caveats
    s = <<-EOS
      If this is your first install, automatically load on login with:
        mkdir -p ~/Library/LaunchAgents
        cp #{prefix}/org.nhabit.Selenium.plist ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/org.nhabit.Selenium.plist
        launchctl start org.nhabit.Selenium
      Check to see that it is running
        ps auxwww | grep selenium

    EOS
    return s
  end

  def startup_plist
    return %Q{
          <?xml version="1.0" encoding="UTF-8"?>
              <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
              <plist version="1.0">
              <dict>
                <key>Label</key>
                <string>org.nhabit.Selenium</string>
                <key>OnDemand</key>
                <true/>
                <key>ProgramArguments</key>
                <array>
                  <string>/usr/bin/java</string>
                  <string>-jar</string>
                  <string>#{prefix}/selenium-server-standalone-2.5.0.jar</string>
                  <string>-port</string>
                  <string>4443</string>
                </array>
                <key>ServiceDescription</key>
                <string>Selenium Server</string>
                <key>StandardErrorPath</key>
                <string>#{prefix}/log/error.log</string>
                <key>StandardOutPath</key>
                <string>#{prefix}/log/output.log</string>
              </dict>
              </plist>
    }
  end

end


