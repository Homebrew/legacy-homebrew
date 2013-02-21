require 'formula'

class Nexus < Formula
  homepage 'http://www.sonatype.org/'
  url 'http://www.sonatype.org/downloads/nexus-2.3.0-04-bundle.tar.gz'
  version '2.3.0-04'
  sha1 '265a3a7bd09f5980d467367c729cf59f24865d11'

  def install
    rm_f Dir['bin/*.bat']
    libexec.install Dir['nexus-2.3.0-04/*']
    bin.install_symlink libexec/'bin/nexus'
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/nexus/libexec/bin/nexus { console | start | stop | restart | status | dump }"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>com.sonatype.nexus</string>
        <key>ProgramArguments</key>
        <array>
          <string>/usr/local/opt/nexus/bin/nexus</string>
          <string>start</string>
        </array>
        <key>RunAtLoad</key>
      <true/>
      </dict>
    </plist>
    EOS
  end
end
