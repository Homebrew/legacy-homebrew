class SeleniumServerStandalone < Formula
  desc "Browser automation for testing purposes"
  homepage "http://seleniumhq.org/"
  url "http://selenium-release.storage.googleapis.com/2.45/selenium-server-standalone-2.45.0.jar"
  sha1 "9bc872d1f364a3104257b1f8e055a342228259c3"

  def install
    libexec.install "selenium-server-standalone-#{version}.jar"
    bin.write_jar_script libexec/"selenium-server-standalone-#{version}.jar", "selenium-server"
  end

  plist_options :manual => "selenium-server -p 4444"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <false/>
      <key>ProgramArguments</key>
      <array>
        <string>/usr/bin/java</string>
        <string>-jar</string>
        <string>#{libexec}/selenium-server-standalone-#{version}.jar</string>
        <string>-port</string>
        <string>4444</string>
      </array>
      <key>ServiceDescription</key>
      <string>Selenium Server</string>
      <key>StandardErrorPath</key>
      <string>#{var}/log/selenium-error.log</string>
      <key>StandardOutPath</key>
      <string>#{var}/log/selenium-output.log</string>
    </dict>
    </plist>
    EOS
  end
end
