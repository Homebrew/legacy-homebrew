# atlassian-jira 6.3.12 (new formula)

class AtlassianJira < Formula
  homepage "https://www.atlassian.com/software/jira/"
  url "http://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-6.3.12.tar.gz"
  sha1 "3638292cd9b280d8aee266b5639a6cc8da4de866"

  depends_on :java => "1.7"

  def install
    # TODO
    data = var/"jira-home"
    inreplace "atlassian-jira/WEB-INF/classes/jira-application.properties",
      'jira.home =', "jira.home=#{data}"

    libexec.install Dir["*"]

    bin.install_symlink libexec/"bin/start-jira.sh"
    bin.install_symlink libexec/"bin/stop-jira.sh"
  end

  def post_install
    # Make sure runtime directories exist
    (var/"jira-home").mkpath
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/atlassian-jira/libexec/bin/start-jira.sh"

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
          <string>bin/start-jira.sh</string>
          <string>-fg</string>
        </array>

        <key>KeepAlive</key>
        <true/>
      </dict>
    </plist>
  EOS
  end

  def caveats; <<-EOS.undent
    Once started Jira will listen on http://localhost:8080/

    If you have Java 7 installed along with other versions, try:
      JAVA_HOME=$(/usr/libexec/java_home -v 1.7) brew install atlassian-jira
    EOS
  end

  test do
    system "#{libexec}/bin/version.sh"
  end
end
