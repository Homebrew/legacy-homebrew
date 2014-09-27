require "formula"

class SeleniumServerStandalone < Formula
  homepage "http://seleniumhq.org/"
  url "http://selenium-release.storage.googleapis.com/2.43/selenium-server-standalone-2.43.1.jar"
  sha1 "ef1b5f8ae9c99332f99ba8794988a1d5b974d27b"

  bottle do
    sha1 "fa420b238130adea8407329e2b459a79eaa939dc" => :mavericks
    sha1 "b0ac2d1411b63c50639be91da20b898d8c7de53f" => :mountain_lion
    sha1 "dc9029c9028d18460fdd9c7e0ba296f05e5acd00" => :lion
  end

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
      <string>/var/log/selenium/selenium-error.log</string>
      <key>StandardOutPath</key>
      <string>/var/log/selenium/selenium-output.log</string>
    </dict>
    </plist>
    EOS
  end
end
