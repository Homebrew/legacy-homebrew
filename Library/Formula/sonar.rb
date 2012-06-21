require 'formula'

class Sonar < Formula
  homepage 'http://www.sonarsource.org'
  url 'http://dist.sonar.codehaus.org/sonar-3.1.zip'
  md5 '9c84e876963ae7594a96ca24442e648a'

  def install
    # Delete native bin directories for other systems
    rm_rf Dir['bin/{aix,hpux,linux,solaris,windows}-*']

    if MacOS.prefer_64_bit?
      rm_rf Dir['bin/macosx-universal-32']
    else
      rm_rf Dir['bin/macosx-universal-64']
    end

    # Delete Windows files
    rm_f Dir['war/*.bat']
    libexec.install Dir['*']

    if MacOS.prefer_64_bit?
      bin.install_symlink "#{libexec}/bin/macosx-universal-64/sonar.sh" => "sonar"
    else
      bin.install_symlink "#{libexec}/bin/macosx-universal-32/sonar.sh" => "sonar"
    end

    plist_path.write startup_plist
    plist_path.chmod 0644
  end

  def caveats; <<-EOS
If this is your first install, automatically load on login with:
    mkdir -p ~/Library/LaunchAgents
    cp #{plist_path} ~/Library/LaunchAgents/
    launchctl load -w ~/Library/LaunchAgents/#{plist_path.basename}

If this is an upgrade and you already have the #{plist_path.basename} loaded:
    launchctl unload -w ~/Library/LaunchAgents/#{plist_path.basename}
    cp #{plist_path} ~/Library/LaunchAgents/
    launchctl load -w ~/Library/LaunchAgents/#{plist_path.basename}

Or start it manually:
   #{HOMEBREW_PREFIX}/bin/sonar console
EOS
  end

  def startup_plist
    return <<-EOS
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>#{plist_name}</string>
    <key>ProgramArguments</key>
    <array>
    <string>#{HOMEBREW_PREFIX}/bin/sonar</string>
    <string>start</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
EOS
  end
end
