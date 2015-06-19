class ScmManager < Formula
  desc "Manage Git, Mercurial, and Subversion repos over HTTP"
  homepage "https://www.scm-manager.org"
  url "https://maven.scm-manager.org/nexus/content/repositories/releases/sonia/scm/scm-server/1.46/scm-server-1.46-app.tar.gz"
  version "1.46"
  sha256 "984737422d403f2db95bdd9f268f900a537413b1d78721929faa53785bf7b54c"

  depends_on :java => "1.6+"

  bottle do
    cellar :any
    sha256 "cb4f58a1ec6c26ee09534d8b6d42c28a21fb461b1d7e4a8ac1a4793d0a0fecf9" => :yosemite
    sha256 "142969086cc96c7300bd92b4cc28063a57e9f014aafbcf45360fee5bae0fba1c" => :mavericks
    sha256 "979071c94926cda759b8270d4d51b0e54c9d70ce4b078864d041b9c926093919" => :mountain_lion
  end

  resource "client" do
    url "https://maven.scm-manager.org/nexus/content/repositories/releases/sonia/scm/clients/scm-cli-client/1.46/scm-cli-client-1.46-jar-with-dependencies.jar"
    version "1.46"
    sha256 "6f0470d119c534eab6ac0b66c41584bf975cf5f3f845d119ad2cde751e675865"
  end

  def install
    rm_rf Dir["bin/*.bat"]

    libexec.install Dir["*"]

    (bin/"scm-server").write <<-EOS.undent
      #!/bin/bash
      BASEDIR="#{libexec}"
      REPO="#{libexec}/lib"
      export JAVA_HOME=$(/usr/libexec/java_home -v 1.6)
      "#{libexec}/bin/scm-server" "$@"
    EOS
    chmod 0755, bin/"scm-server"

    tools = libexec/"tools"
    tools.install resource("client")

    scmCliClient = bin+"scm-cli-client"
    scmCliClient.write <<-EOS.undent
      #!/bin/bash
      java -jar "#{tools}/scm-cli-client-#{version}-jar-with-dependencies.jar" "$@"
    EOS
    chmod 0755, scmCliClient
  end

  plist_options :manual => "scm-server start"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/scm-server</string>
          <string>start</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
    EOS
  end
end
