require 'formula'

class Memcached < Formula
  homepage 'http://memcached.org/'
  url "http://memcached.googlecode.com/files/memcached-1.4.14.tar.gz"
  sha1 'b360a6acf2454452c6fd4a5bdbbc303d85c3ec27'

  depends_on 'libevent'

  def options
    [
      ["--enable-sasl", "Enable SASL support -- disables ASCII protocol!"],
      ["--enable-sasl-pwdb", "Enable SASL with memcached's own plain text password db support -- disables ASCII protocol!"],
    ]
  end

  def install
    args = ["--prefix=#{prefix}"]
    args << "--enable-sasl" if ARGV.include? "--enable-sasl"
    args << "--enable-sasl-pwdb" if ARGV.include? "--enable-sasl-pwdb"

    system "./configure", *args
    system "make install"

    plist_path.write startup_plist
    plist_path.chmod 0644
  end

  def caveats; <<-EOS.undent
    You can enable memcached to automatically load on login with:
        mkdir -p ~/Library/LaunchAgents
        cp #{plist_path} ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/#{plist_path.basename}

    If this is an upgrade and you already have the #{plist_path.basename} loaded:
        launchctl unload -w ~/Library/LaunchAgents/#{plist_path.basename}
        cp #{plist_path} ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/#{plist_path.basename}

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
  <string>#{plist_name}</string>
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
