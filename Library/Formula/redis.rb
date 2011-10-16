require 'formula'

class Redis < Formula
  url 'http://redis.googlecode.com/files/redis-2.4.0.tar.gz'
  head 'https://github.com/antirez/redis.git'
  homepage 'http://redis.io/'
  md5 'efdfa0d40fc7676199005bd0178cf6a9'

  fails_with_llvm 'Fails with "reference out of range from _linenoise"', :build => 2334

  def install
    # Architecture isn't detected correctly on 32bit Snow Leopard without help
    ENV["OBJARCH"] = MacOS.prefer_64_bit? ? "-arch x86_64" : "-arch i386"

    # Head and stable have different code layouts
    src = File.exists?('src/Makefile') ? 'src' : '.'
    system "make -C #{src}"

    %w( redis-benchmark redis-cli redis-server redis-check-dump redis-check-aof ).each { |p|
      bin.install "#{src}/#{p}" rescue nil
    }

    %w( run db/redis log ).each { |p| (var+p).mkpath }

    # Fix up default conf file to match our paths
    inreplace "redis.conf" do |s|
      s.gsub! "/var/run/redis.pid", "#{var}/run/redis.pid"
      s.gsub! "dir ./", "dir #{var}/db/redis/"
    end

    doc.install Dir["doc/*"]
    etc.install "redis.conf"
    (prefix+'io.redis.redis-server.plist').write startup_plist
    (prefix+'io.redis.redis-server.plist').chmod 0644
  end

  def caveats
    <<-EOS.undent
    If this is your first install, automatically load on login with:
        mkdir -p ~/Library/LaunchAgents
        cp #{prefix}/io.redis.redis-server.plist ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/io.redis.redis-server.plist

    If this is an upgrade and you already have the io.redis.redis-server.plist loaded:
        launchctl unload -w ~/Library/LaunchAgents/io.redis.redis-server.plist
        cp #{prefix}/io.redis.redis-server.plist ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/io.redis.redis-server.plist

      To start redis manually:
        redis-server #{etc}/redis.conf

      To access the server:
        redis-cli
    EOS
  end

  def startup_plist
    return <<-EOPLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>KeepAlive</key>
    <true/>
    <key>Label</key>
    <string>io.redis.redis-server</string>
    <key>ProgramArguments</key>
    <array>
      <string>#{bin}/redis-server</string>
      <string>#{etc}/redis.conf</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>UserName</key>
    <string>#{`whoami`.chomp}</string>
    <key>WorkingDirectory</key>
    <string>#{var}</string>
    <key>StandardErrorPath</key>
    <string>#{var}/log/redis.log</string>
    <key>StandardOutPath</key>
    <string>#{var}/log/redis.log</string>
  </dict>
</plist>
    EOPLIST
  end
end
