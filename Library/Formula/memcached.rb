require 'formula'

class Memcached < Formula
  url "http://memcached.googlecode.com/files/memcached-1.4.10.tar.gz"
  homepage 'http://memcached.org/'
  sha1 '0ae300f858b767abf812009d53ed58647ceb498a'

  depends_on 'libevent'

  def options
    [
      ["--enable-sasl", "Enable SASL support -- disables ASCII protocol!"],
    ]
  end

  def install
    args = ["--prefix=#{prefix}"]
    args << "--enable-sasl" if ARGV.include? "--enable-sasl"

    system "./configure", *args
    system "make install"

    (prefix+'com.danga.memcached.plist').write startup_plist
    (prefix+'com.danga.memcached.plist').chmod 0644
  end

  def caveats; <<-EOS.undent
    You can enable memcached to automatically load on login with:
        mkdir -p ~/Library/LaunchAgents
        cp #{prefix}/com.danga.memcached.plist ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/com.danga.memcached.plist

    If this is an upgrade and you already have the com.danga.memcached.plist loaded:
        launchctl unload -w ~/Library/LaunchAgents/com.danga.memcached.plist
        cp #{prefix}/com.danga.memcached.plist ~/Library/LaunchAgents/com.danga.memcached.plist
        launchctl load -w ~/Library/LaunchAgents/com.danga.memcached.plist

    Or start it manually:
        #{HOMEBREW_PREFIX}/bin/memcached

    Add "-d" to start it as a daemon.
    EOS
  end

  def startup_plist
    return <<-EOPLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>com.danga.memcached</string>
  <key>KeepAlive</key>
  <true/>
  <key>ProgramArguments</key>
  <array>
    <string>#{HOMEBREW_PREFIX}/bin/memcached</string>
    <string>-l</string>
    <string>localhost</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
  <key>WorkingDirectory</key>
  <string>#{HOMEBREW_PREFIX}</string>
</dict>
</plist>
    EOPLIST
  end
end
