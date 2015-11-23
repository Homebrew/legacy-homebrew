class ApacheArchiva < Formula
  desc "The Build Artifact Repository Manager"
  homepage "https://archiva.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=archiva/2.2.0/binaries/apache-archiva-2.2.0-bin.tar.gz"
  sha256 "6af7c3c47c35584f729a9c139675a01f9a9819d0cdde292552fc783284a34cfa"

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    libexec.install Dir["*"]

    bin.install_symlink libexec/"bin/archiva"
  end

  def post_install
    (var/"archiva/logs").mkpath
    (var/"archiva/data").mkpath
    (var/"archiva/temp").mkpath

    cp_r libexec/"conf", var/"archiva"
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/archiva</string>
          <string>console</string>
        </array>
        <key>Disabled</key>
        <false/>
        <key>RunAtLoad</key>
        <true/>
        <key>UserName</key>
        <string>archiva</string>
        <key>StandardOutPath</key>
        <string>#{var}/archiva/logs/launchd.log</string>
        <key>EnvironmentVariables</key>
        <dict>
          <key>ARCHIVA_BASE</key>
          <string>#{var}/archiva</string>
        </dict>
      </dict>
    </plist>
    EOS
  end

  test do
    assert_match "was not running.", shell_output("#{bin}/archiva stop")
  end
end
