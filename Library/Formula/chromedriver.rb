class Chromedriver < Formula
  desc "Tool for automated testing of webapps across many browsers"
  homepage "https://sites.google.com/a/chromium.org/chromedriver/"
  url "https://chromedriver.storage.googleapis.com/2.19/chromedriver_mac32.zip"
  version "2.19"
  sha256 "7bce0af6739db1a21086dd509a1d382796f254e063de58344c9071bb7b49c91b"

  bottle do
    cellar :any
    sha256 "e21c9f5dc6c28a842f85cff78cd5b407fe5f134427d2e736be6aaa9a302c51b4" => :yosemite
    sha256 "1b30598a6a5ac42bc36e3b672841c5cd8d70d0afe0d34d8703d7519bf521b0d8" => :mavericks
    sha256 "bb9731138c804c4eb7398fa1b716ded80609630a99172e2b673bb7a969d2621d" => :mountain_lion
  end

  def install
    bin.install "chromedriver"
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

  test do
    driver = fork do
      exec bin/"chromedriver",
             "--port=9999", "--log-path=#{testpath}/cd.log"
    end
    sleep 5
    Process.kill("TERM", driver)
    File.exist? testpath/"cd.log"
  end
end
