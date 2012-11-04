require 'formula'

class Memcached < Formula
  homepage 'http://memcached.org/'
  url "http://memcached.googlecode.com/files/memcached-1.4.15.tar.gz"
  sha1 '12ec84011f408846250a462ab9e8e967a2e8cbbc'

  depends_on 'libevent'

  option "enable-sasl", "Enable SASL support -- disables ASCII protocol!"
  option "enable-sasl-pwdb", "Enable SASL with memcached's own plain text password db support -- disables ASCII protocol!"

  def install
    args = ["--prefix=#{prefix}", "--disable-coverage"]
    args << "--enable-sasl" if build.include? "enable-sasl"
    args << "--enable-sasl-pwdb" if build.include? "enable-sasl-pwdb"

    system "./configure", *args
    system "make install"
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
