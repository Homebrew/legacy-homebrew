require 'formula'

class ScmManager < Formula
  homepage 'http://www.scm-manager.org'
  url 'http://maven.scm-manager.org/nexus/content/repositories/releases/sonia/scm/scm-server/1.41/scm-server-1.41-app.tar.gz'
  version '1.41'
  sha1 'b8dfa7b1c5c009b2633f89655a1df631a7d5afd4'

  resource 'client' do
    url 'http://maven.scm-manager.org/nexus/content/repositories/releases/sonia/scm/clients/scm-cli-client/1.41/scm-cli-client-1.41-jar-with-dependencies.jar'
    sha1 '26e969810c87924da3018e4a7bae6685deb717fc'
  end

  def install
    rm_rf Dir['bin/*.bat']

    libexec.install Dir['*']

    (bin/'scm-server').write <<-EOS.undent
      #!/bin/bash
      BASEDIR="#{libexec}"
      REPO="#{libexec}/lib"
      export JAVA_HOME=$(/usr/libexec/java_home -v 1.6)
      "#{libexec}/bin/scm-server" "$@"
    EOS
    chmod 0755, bin/'scm-server'

    tools = libexec/'tools'
    tools.install resource('client')

    scmCliClient = bin+'scm-cli-client'
    scmCliClient.write <<-EOS.undent
      #!/bin/bash
      java -jar "#{tools}/scm-cli-client-#{version}-jar-with-dependencies.jar" "$@"
    EOS
    chmod 0755, scmCliClient
  end

  plist_options :manual => 'scm-server start'

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
