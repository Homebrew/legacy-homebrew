require 'formula'

class ScmManager < Formula
  homepage 'http://www.scm-manager.org'
  url 'http://maven.scm-manager.org/nexus/content/repositories/releases/sonia/scm/scm-server/1.34/scm-server-1.34-app.tar.gz'
  version '1.34'
  sha1 'a24a13fc9ba7c80355f210052e95c4b92eb1f2cf'

  skip_clean 'libexec/var/log'

  resource 'client' do
    url 'http://maven.scm-manager.org/nexus/content/repositories/releases/sonia/scm/clients/scm-cli-client/1.34/scm-cli-client-1.34-jar-with-dependencies.jar'
    sha1 '0753518a2d33e51fd7778ae243878e4d3d0a3a90'
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
