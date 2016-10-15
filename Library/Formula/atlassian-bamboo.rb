class AtlassianBamboo < Formula
  homepage "https://www.atlassian.com/software/bamboo"
  url "http://www.atlassian.com/software/bamboo/downloads/binary/atlassian-bamboo-5.7.2.tar.gz"
  sha256 "b378500ea61803333fc27b0a42cfbdfbce5dccc75cead0b464dbc4e5e0bddb17"

  depends_on :java => "1.7"

  def install
    data = var/"bamboo-home"
    inreplace "atlassian-bamboo/WEB-INF/classes/bamboo-init.properties",
      '#bamboo.home=C:/bamboo/bamboo-home', "bamboo.home=#{data}"

    libexec.install Dir["*"]

    bin.install_symlink libexec/"bin/start-bamboo.sh"
    bin.install_symlink libexec/"bin/stop-bamboo.sh"
  end

  def post_install
    # Make sure runtime directories exist
    (var/"bamboo-home").mkpath
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/atlassian-bamboo/libexec/bin/start-bamboo.sh"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>

        <key>WorkingDirectory</key>
        <string>#{libexec}</string>

        <key>ProgramArguments</key>
        <array>
          <string>bin/start-bamboo.sh</string>
          <string>-fg</string>
        </array>

        <key>KeepAlive</key>
        <true/>
      </dict>
    </plist>
  EOS
  end

  def caveats; <<-EOS.undent
    Once started Bamboo will listen on http://localhost:8085/

    If you have Java 7 installed along with other versions, try:
      JAVA_HOME=$(/usr/libexec/java_home -v 1.7) brew install atlassian-bamboo
    EOS
  end

  test do
    system "#{libexec}/bin/version.sh"
  end
end
