require 'formula'

class PerforceProxy < Formula
  homepage 'http://www.perforce.com/'

  if MacOS.prefer_64_bit?
    url 'http://filehost.perforce.com/perforce/r12.1/bin.darwin90x86_64/p4p'
    version '2012.1.490371-x86_64'
    sha1 '6eae7e5f020fdc0c7aa43a176d77d72171ada2fa'
  else
    url 'http://filehost.perforce.com/perforce/r12.1/bin.darwin90x86/p4p'
    version '2012.1.490371-x86'
    sha1 '68e67031dee15ecc19622d886a4f75b086d8008c'
  end

  def install
    sbin.install 'p4p'

    (var+"p4p").mkpath

    plist_path.write startup_plist
    plist_path.chmod 0644
  end

  def caveats; <<-EOS.undent
    To use the Perforce proxy to access your Perforce server, set your P4PORT
    environment variable to "localhost:1666".

    To launch on startup:
    * if this is your first install:
        mkdir -p ~/Library/LaunchAgents
        cp #{plist_path} ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/#{plist_path.basename}

    * if this is an upgrade and you already have the #{plist_path.basename} loaded:
        launchctl unload -w ~/Library/LaunchAgents/#{plist_path.basename}
        cp #{plist_path} ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/#{plist_path.basename}

    Before starting the proxy server, you probably need to edit the plist to use
    the correct host and port for your Perforce server (replacing the default
    perforce:1666).
    EOS
  end

  def startup_plist; <<-EOPLIST.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{HOMEBREW_PREFIX}/sbin/p4p</string>
        <string>-p</string>
        <string>1666</string>
        <string>-r</string>
        <string>#{var}/p4p</string>
        <string>-t</string>
        <string>perforce:1666</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <true/>
      <key>UserName</key>
      <string>#{`whoami`.chomp}</string>
      <key>WorkingDirectory</key>
      <string>#{var}/p4p</string>
    </dict>
    </plist>
    EOPLIST
  end
end
