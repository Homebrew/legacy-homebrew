require 'formula'

class Nexus < Formula
  homepage 'http://www.sonatype.org/'
  url 'http://download.sonatype.com/nexus/oss/nexus-2.3.1-bundle.tar.gz'
  sha1 'f064052500223e7af3e3323b6bc9fb7c047ac0e1'

  # Put the sonatype-work directory in the var directory, to persist across version updates
  def patches
    DATA
  end

  def install
    rm_f Dir['bin/*.bat']
    libexec.install Dir["nexus-2.3.1-01/*"]
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

  def caveats; <<-EOS.undent
    If you are upgrading nexus for the first time, and old version is less than 2.3.1, then
    you will need to copy the sonatype-work directory from:
      #{HOMEBREW_PREFIX}/Cellar/#{name}/<old version>/
    to
      #{var}
    EOS
  end
end

__END__
diff --git a/nexus-2.3.1-01/conf/nexus.properties b/nexus-2.3.1/conf/nexus.properties
index df89251..23b536b 100644
--- a/nexus-2.3.1-01/conf/nexus.properties
+++ b/nexus-2.3.1-01/conf/nexus.properties
@@ -22,5 +22,5 @@ nexus-webapp=${bundleBasedir}/nexus
 nexus-webapp-context-path=/nexus

 # Nexus section
-nexus-work=${bundleBasedir}/../sonatype-work/nexus
+nexus-work=HOMEBREW_PREFIX/var/nexus
 runtime=${bundleBasedir}/nexus/WEB-INF
