require 'formula'

class ScmManagerCliClient < Formula
  homepage 'http://www.scm-manager.org'
  url 'http://maven.scm-manager.org/nexus/content/repositories/releases/sonia/scm/clients/scm-cli-client/1.25/scm-cli-client-1.25-jar-with-dependencies.jar'
  version '1.25'
  sha1 '37e1d257c4ce1f688be7bc5b193a992888e0aa0e'
end

class ScmManager < Formula
  homepage 'http://www.scm-manager.org'
  url 'http://maven.scm-manager.org/nexus/content/repositories/releases/sonia/scm/scm-server/1.25/scm-server-1.25-app.tar.gz'
  version '1.25'
  sha1 '38a2871de8b38d29129e04993a74d2f3006614c2'

  skip_clean 'libexec/var/log'

  def install
    rm_rf Dir['bin/*.bat']

    libexec.install Dir['*']

    (bin/'scm-server').write <<-EOS.undent
      #!/bin/bash
      BASEDIR="#{libexec}"
      REPO="#{libexec}/lib"
      "#{libexec}/bin/scm-server" "$@"
    EOS
    chmod 0755, bin/'scm-server'

    tools = libexec/'tools'
    ScmManagerCliClient.new.brew { tools.install Dir['*'] }

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
          <string>#{opt_prefix}/bin/scm-server</string>
          <string>start</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
    EOS
  end
end
