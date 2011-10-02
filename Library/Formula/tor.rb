require 'formula'

class Tor < Formula
  url 'https://www.torproject.org/dist/tor-0.2.2.33.tar.gz'
  homepage 'https://www.torproject.org/'
  md5 'ea99aba49694bb982d2fccc57a70d58e'

  depends_on 'libevent'

  def patches
    {:p0 => 'https://gist.github.com/raw/344132/d27d1cd3042d7c58120688d79ed25a2fc959a2de/config.guess-x86_64patch.diff' }
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"

    (prefix+'org.tor.plist').write startup_plist
    (prefix+'org.tor.plist').chmod 0644
  end

  def startup_plist
    return <<-EOPLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>org.tor</string>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>UserName</key>
    <string>#{`whoami`.chomp}</string>
    <key>ProgramArguments</key>
    <array>
        <string>#{bin}/tor</string>
    </array>
    <key>WorkingDirectory</key>
    <string>#{HOMEBREW_PREFIX}</string>
  </dict>
</plist>
    EOPLIST
  end

  def caveats; <<-EOS.undent
    You can start tor automatically on login with:
      mkdir -p ~/Library/LaunchAgents
      cp #{prefix}/org.tor.plist ~/Library/LaunchAgents/
      launchctl load -w ~/Library/LaunchAgents/org.tor.plist
    EOS
  end
end
