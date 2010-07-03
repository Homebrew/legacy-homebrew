require 'formula'

class Redis <Formula
  url 'http://redis.googlecode.com/files/redis-1.2.6.tar.gz'
  head 'git://github.com/antirez/redis.git'
  homepage 'http://code.google.com/p/redis/'
  sha1 'c71aef0b3f31acb66353d86ba57dd321b541043f'

  def install
    fails_with_llvm "Breaks with LLVM"

    # Head and stable have different code layouts
    src = File.exists?('src/Makefile') ? 'src' : '.'
    system "make -C #{src}"

    %w( redis-benchmark redis-cli redis-server redis-stat redis-check-dump ).each { |p|
      # Some of these commands are only in 1.2.x, some only in head
      bin.install "#{src}/#{p}" rescue nil
    }

    %w( run db/redis log ).each { |p| (var+p).mkpath }

    # Fix up default conf file to match our paths
    inreplace "redis.conf" do |s|
      s.gsub! "/var/run/redis.pid", "#{var}/run/redis.pid"
      s.gsub! "dir ./", "dir #{var}/db/redis/"
    end

    etc.install "redis.conf"
    (prefix+'io.redis.redis-server.plist').write startup_plist
  end

  def caveats
    <<-EOS.undent
      Automatically load on login with:
        launchctl load -w #{prefix}/io.redis.redis-server.plist

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
