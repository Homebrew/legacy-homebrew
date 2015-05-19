class ScmManager < Formula
  desc "Manage Git, Mercurial, and Subversion repos over HTTP"
  homepage "http://www.scm-manager.org"
  url "http://maven.scm-manager.org/nexus/content/repositories/releases/sonia/scm/scm-server/1.45/scm-server-1.45-app.tar.gz"
  version "1.45"
  sha1 "c8a2e9c694525a570460639bbb5cb01b23595ec4"

  bottle do
    sha1 "4ed2b53994cf1f31bde45a4e819906c39b218ca3" => :yosemite
    sha1 "38d785287fc539b1b807acfa41c24a58c1cdb2d5" => :mavericks
    sha1 "0b1169a36a9da089dc2d2257dfc473b16b5ad1f5" => :mountain_lion
  end

  resource "client" do
    url "http://maven.scm-manager.org/nexus/content/repositories/releases/sonia/scm/clients/scm-cli-client/1.45/scm-cli-client-1.45-jar-with-dependencies.jar"
    version "1.45"
    sha1 "debfe596c1d959f7c1c282c747f728818e62b321"
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
