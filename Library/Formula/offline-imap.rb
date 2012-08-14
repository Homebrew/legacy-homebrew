require 'formula'

class OfflineImap < Formula
  homepage 'http://offlineimap.org/'
  url 'https://github.com/downloads/spaetz/offlineimap/offlineimap-v6.5.4.tar.gz'
  md5 'f696978785ecfc804271ec25100ef929'

  head 'https://github.com/spaetz/offlineimap.git'

  def install
    prefix.install 'offlineimap.conf', 'offlineimap.conf.minimal'
    libexec.install 'bin/offlineimap' => 'offlineimap.py'
    libexec.install 'offlineimap'
    bin.install_symlink libexec+'offlineimap.py' => 'offlineimap'

    plist_path.write startup_plist
    plist_path.chmod 0644
  end

  def caveats; <<-EOS.undent
    To get started, copy one of these configurations to ~/.offlineimaprc:
    * minimal configuration:
        cp -n #{prefix}/offlineimap.conf.minimal ~/.offlineimaprc

    * advanced configuration:
        cp -n #{prefix}/offlineimap.conf ~/.offlineimaprc


    To launch on startup and run every 5 minutes:
    * if this is your first install:
        mkdir -p ~/Library/LaunchAgents
        cp #{plist_path} ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/#{plist_path.basename}

    * if this is an upgrade and you already have the #{plist_path.basename} loaded:
        launchctl unload -w ~/Library/LaunchAgents/#{plist_path.basename}
        cp #{plist_path} ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/#{plist_path.basename}

    EOS
  end

  def startup_plist; <<-EOPLIST.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <false/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{HOMEBREW_PREFIX}/bin/offlineimap</string>
        </array>
        <key>StartInterval</key>
        <integer>300</integer>
        <key>RunAtLoad</key>
        <true />
        <key>StandardErrorPath</key>
        <string>/dev/null</string>
        <key>StandardOutPath</key>
        <string>/dev/null</string>
      </dict>
    </plist>
    EOPLIST
  end
end
