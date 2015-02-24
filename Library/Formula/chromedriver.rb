require 'formula'

class Chromedriver < Formula
  homepage 'https://sites.google.com/a/chromium.org/chromedriver/'
  url 'http://chromedriver.storage.googleapis.com/2.14/chromedriver_mac32.zip'
  sha256 '33ee96ea17b00dd8e14e15ca6fe1b1fd4ae7a71f86d8785e562e88d839299d2e'
  version '2.14'

  def install
    bin.install 'chromedriver'
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>homebrew.mxcl.chromedriver</string>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <false/>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/chromedriver</string>
      </array>
      <key>ServiceDescription</key>
      <string>Chrome Driver</string>
      <key>StandardErrorPath</key>
      <string>#{var}/log/chromedriver-error.log</string>
      <key>StandardOutPath</key>
      <string>#{var}/log/chromedriver-output.log</string>
    </dict>
    </plist>
    EOS
  end
end
