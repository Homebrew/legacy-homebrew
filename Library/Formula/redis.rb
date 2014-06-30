require 'formula'

class Redis < Formula
  homepage 'http://redis.io/'
  url "http://download.redis.io/releases/redis-2.8.12.tar.gz"
  sha1 "56c86a4f9eccaf29f934433c7c67a175e404b2f6"

  bottle do
    sha1 "4b1e2d66d2202498aec7b99bc503458f26bc7432" => :mavericks
    sha1 "536c1d27ebf94b8331d262b2adc3166a57dfc4b4" => :mountain_lion
    sha1 "66613e9bd2a314de17bc21562eac954ad0a35355" => :lion
  end

  head 'https://github.com/antirez/redis.git', :branch => 'unstable'

  fails_with :llvm do
    build 2334
    cause 'Fails with "reference out of range from _linenoise"'
  end

  def install
    # Architecture isn't detected correctly on 32bit Snow Leopard without help
    ENV["OBJARCH"] = "-arch #{MacOS.preferred_arch}"

    # Head and stable have different code layouts
    src = (buildpath/'src/Makefile').exist? ? buildpath/'src' : buildpath
    system "make", "-C", src, "CC=#{ENV.cc}"

    %w[benchmark cli server check-dump check-aof sentinel].each { |p| bin.install src/"redis-#{p}" }
    %w[run db/redis log].each { |p| (var+p).mkpath }

    # Fix up default conf file to match our paths
    inreplace "redis.conf" do |s|
      s.gsub! "/var/run/redis.pid", "#{var}/run/redis.pid"
      s.gsub! "dir ./", "dir #{var}/db/redis/"
      s.gsub! "\# bind 127.0.0.1", "bind 127.0.0.1"
    end

    etc.install 'redis.conf'
    etc.install 'sentinel.conf' => 'redis-sentinel.conf'
  end

  plist_options :manual => "redis-server #{HOMEBREW_PREFIX}/etc/redis.conf"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <dict>
          <key>SuccessfulExit</key>
          <false/>
        </dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/redis-server</string>
          <string>#{etc}/redis.conf</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/redis.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/redis.log</string>
      </dict>
    </plist>
    EOS
  end

  test do
    system "#{bin}/redis-server", "--test-memory", "2"
  end
end
