require 'formula'

class Tor < Formula
  url 'https://www.torproject.org/dist/tor-0.2.2.34.tar.gz'
  homepage 'https://www.torproject.org/'
  md5 '0f1bbb8e086ea2aba41ff7f898fcf3bd'

  depends_on 'libevent'

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
