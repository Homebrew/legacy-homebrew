require 'formula'

class ScmManagerCliClient < Formula
  url 'http://maven.scm-manager.org/nexus/content/repositories/releases/sonia/scm/clients/scm-cli-client/1.13/scm-cli-client-1.13-jar-with-dependencies.jar'
  homepage 'http://www.scm-manager.org'
  md5 '3d79ea68075ab0f8891aaf591f87224b'
  version '1.13'
end

class ScmManager < Formula
  url 'http://maven.scm-manager.org/nexus/content/repositories/releases/sonia/scm/scm-server/1.13/scm-server-1.13-app.tar.gz'
  homepage 'http://www.scm-manager.org'
  md5 'd2923425425cd233539c6750ae54889d'
  version '1.13'

  skip_clean :all

  def install
    rm_rf Dir['bin/*.bat']
    libexec.install Dir['*']
    bin.mkpath
    Dir["#{libexec}/bin/*"].each do |f|
      scriptname = File.basename(f)
      (bin+scriptname).write <<-EOS.undent
      #!/bin/bash
      BASEDIR="#{libexec}"
      REPO="#{libexec}/lib"
      #{f} $@
      EOS
      chmod 0755, bin+scriptname
    end

    tools = (libexec + 'tools')
    tools.mkpath

    ScmManagerCliClient.new.brew {
      tools.install Dir['*']
      bin.mkpath
      scmCliClient = bin+'scm-cli-client'
      scmCliClient.write <<-EOS.undent
        #!/bin/bash
        /usr/bin/java -jar #{tools}/scm-cli-client-#{version}-jar-with-dependencies.jar $@
      EOS
      chmod 0755, scmCliClient
    }

    (prefix+'org.scm-manager.plist').write create_launch_agent
    (prefix+'org.scm-manager.plist').chmod 0644
  end

  def caveats; <<-EOS
If this is your first install, automatically load on login with:
mkdir -p ~/Library/LaunchAgents
cp #{prefix}/org.scm-manager.plist ~/Library/LaunchAgents/
launchctl load -w ~/Library/LaunchAgents/org.scm-manager.plist

If this is an upgrade and you already have the org.scm-manager.plist loaded:
launchctl unload -w ~/Library/LaunchAgents/org.scm-manager.plist
cp #{prefix}/org.scm-manager.plist ~/Library/LaunchAgents/
launchctl load -w ~/Library/LaunchAgents/org.scm-manager.plist

Or start it manually:
scm-server start
EOS
  end

def create_launch_agent
    return <<-EOS
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>SCM-Manager</string>
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
