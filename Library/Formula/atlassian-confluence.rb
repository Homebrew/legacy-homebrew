# Formula for local Confluence testing

class AtlassianConfluence < Formula
  homepage "https://www.atlassian.com/software/confluence/"
  url "http://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-5.6.5.tar.gz"
  sha1 "4999940f0b0837961d72310128d8376c4025c504"

  depends_on :java => "1.7"

  def install
    # TODO
    data = var/"confluence-home"
    inreplace "confluence/WEB-INF/classes/confluence-init.properties",
      '# confluence.home=c:/confluence/data', "confluence.home=#{data}"

    libexec.install Dir["*"]

    bin.install_symlink libexec/"bin/start-confluence.sh"
    bin.install_symlink libexec/"bin/stop-confluence.sh"
  end

  def post_install
    # Make sure runtime directories exist
    (var/"confluence-home").mkpath
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/atlassian-confluence/libexec/bin/start-confluence.sh"

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
          <string>bin/start-confluence.sh</string>
          <string>-fg</string>
        </array>

        <key>KeepAlive</key>
        <true/>
      </dict>
    </plist>
  EOS
  end

  def caveats; <<-EOS.undent
    Once started Confluence will listen on http://localhost:8090/

    If you have Java 7 installed along with other versions, try:
      JAVA_HOME=$(/usr/libexec/java_home -v 1.7) brew install atlassian-confluence
    EOS
  end

  test do
    system "#{libexec}/bin/version.sh"
  end
end
