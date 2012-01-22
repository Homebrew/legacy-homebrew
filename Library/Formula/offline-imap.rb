require 'formula'

class OfflineImap < Formula
  url "https://github.com/downloads/spaetz/offlineimap/offlineimap-v6.5.2.tar.gz"
  md5 '0ccb6b7e4723a414ea50abb27450a56f'
  head "https://github.com/spaetz/offlineimap.git"
  homepage "http://offlineimap.org/"

  def install
    libexec.install 'bin/offlineimap' => 'offlineimap.py'
    libexec.install 'offlineimap'
    prefix.install [ 'offlineimap.conf', 'offlineimap.conf.minimal' ]
    bin.mkpath
    ln_s libexec+'offlineimap.py', bin+'offlineimap'
    (prefix+'org.offlineimap.plist').write startup_plist
    (prefix+'org.offlineimap.plist').chmod 0644
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
        cp #{prefix}/org.offlineimap.plist ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/org.offlineimap.plist

    * if this is an upgrade and you already have the org.offlineimap.plist loaded:
        launchctl unload -w ~/Library/LaunchAgents/org.offlineimap.plist
        cp #{prefix}/org.offlineimap.plist ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/org.offlineimap.plist

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
        <string>org.offlineimap</string>
        <key>ProgramArguments</key>
        <array>
          <string>/usr/local/bin/offlineimap</string>
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
