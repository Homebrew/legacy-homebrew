require 'formula'

class Memcached < Formula
  url "http://memcached.googlecode.com/files/memcached-1.4.5.tar.gz"
  homepage 'http://www.danga.com/memcached/'
  sha1 'c7d6517764b82d23ae2de76b56c2494343c53f02'

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
  end

  def caveats; <<-EOS.undent
    You can enable memcached to automatically load on login with:
        mkdir -p ~/Library/LaunchAgents
        cp #{prefix}/com.danga.memcached.plist ~/Library/LaunchAgents/
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
