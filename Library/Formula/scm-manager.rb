class ScmManager < Formula
  homepage "http://www.scm-manager.org"
  url "http://maven.scm-manager.org/nexus/content/repositories/releases/sonia/scm/scm-server/1.44/scm-server-1.44-app.tar.gz"
  version "1.44"
  sha1 "341ec08b75c9da21e5cfb165848478de3ad38b2e"

  bottle do
    sha1 "275c0cd713cffa2205c433ddf457956de8601ec9" => :yosemite
    sha1 "31d023d124dc9beb35a7300771f3726d56e2d684" => :mavericks
    sha1 "a4147f15f535216f8c6579806bf0436e0c6666c8" => :mountain_lion
  end

  resource "client" do
    url "http://maven.scm-manager.org/nexus/content/repositories/releases/sonia/scm/clients/scm-cli-client/1.44/scm-cli-client-1.44-jar-with-dependencies.jar"
    version "1.44"
    sha1 "35203ef1d6761233600144cf881748e3c939848f"
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
