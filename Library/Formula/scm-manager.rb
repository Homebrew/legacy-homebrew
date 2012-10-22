require 'formula'

class ScmManagerCliClient < Formula
  homepage 'http://www.scm-manager.org'
  url 'http://maven.scm-manager.org/nexus/content/repositories/releases/sonia/scm/clients/scm-cli-client/1.21/scm-cli-client-1.21-jar-with-dependencies.jar'
  version '1.21'
  sha1 '286a53e90aa44b351d96e8682ae97ee9e6c24e7b'
end

class ScmManager < Formula
  homepage 'http://www.scm-manager.org'
  url 'http://maven.scm-manager.org/nexus/content/repositories/releases/sonia/scm/scm-server/1.21/scm-server-1.21-app.tar.gz'
  version '1.21'
  sha1 '6fe9969c1000546fee28a6f3f6c4aa631d772371'

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

  def caveats; <<-EOS.undent
    If this is your first install, automatically load on login with:
        mkdir -p ~/Library/LaunchAgents
        cp #{plist_path} ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/#{plist_path.basename}

    If this is an upgrade and you already have the #{plist_path.basename} loaded:
        launchctl unload -w ~/Library/LaunchAgents/#{plist_path.basename}
        cp #{plist_path} ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/#{plist_path.basename}

    Or start manually:
      scm-server start
    EOS
  end

def startup_plist; <<-EOS
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>#{plist_name}</string>
    <key>ProgramArguments</key>
    <array>
      <string>#{bin}/scm-server</string>
      <string>start</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
  </dict>
</plist>
EOS
  end
end
