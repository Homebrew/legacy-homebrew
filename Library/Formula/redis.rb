require 'formula'

class Redis < Formula
  url 'http://redis.googlecode.com/files/redis-2.4.6.tar.gz'
  head 'https://github.com/antirez/redis.git', :branch => 'unstable'
  homepage 'http://redis.io/'
  md5 '41d394074bcde762872ecb5506f35aee'

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
    plist_path.write startup_plist
    plist_path.chmod 0644
  end

  def caveats
    <<-EOS.undent
    If this is your first install, automatically load on login with:
        mkdir -p ~/Library/LaunchAgents
        cp #{plist_path} ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/#{plist_path.basename}

    If this is an upgrade and you already have the #{plist_path.basename} loaded:
        launchctl unload -w ~/Library/LaunchAgents/#{plist_path.basename}
        cp #{plist_path} ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/#{plist_path.basename}

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
    <string>#{plist_name}</string>
    <key>ProgramArguments</key>
    <array>
      <string>#{HOMEBREW_PREFIX}/bin/redis-server</string>
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
