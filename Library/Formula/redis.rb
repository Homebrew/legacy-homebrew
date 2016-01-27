class Redis < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "http://redis.io/"
  url "http://download.redis.io/releases/redis-3.0.7.tar.gz"
  sha256 "58966575cedd1b1bb90a9251a13913a866c4dc34c4a26f194be20deca9c0b59e"

  bottle do
    cellar :any_skip_relocation
    sha256 "ed090c79fc9985af30a1eb09ded13b21fc8b1296e75c531c935a3d21781773eb" => :el_capitan
    sha256 "7fd6324784970a7be7ac64b89aca156b987023b28b92ea1ab1404b58a80e5d92" => :yosemite
    sha256 "df74ebb0e27b14e2d2d3caa4d8cb125010de2bc67a230d8a4c550817158a066e" => :mavericks
  end

  option "with-jemalloc", "Select jemalloc as memory allocator when building Redis"

  head "https://github.com/antirez/redis.git", :branch => "unstable"

  fails_with :llvm do
    build 2334
    cause "Fails with \"reference out of range from _linenoise\""
  end

  def install
    # Architecture isn't detected correctly on 32bit Snow Leopard without help
    ENV["OBJARCH"] = "-arch #{MacOS.preferred_arch}"

    args = %W[
      PREFIX=#{prefix}
      CC=#{ENV.cc}
    ]
    args << "MALLOC=jemalloc" if build.with? "jemalloc"
    system "make", "install", *args

    %w[run db/redis log].each { |p| (var+p).mkpath }

    # Fix up default conf file to match our paths
    inreplace "redis.conf" do |s|
      s.gsub! "/var/run/redis.pid", "#{var}/run/redis.pid"
      s.gsub! "dir ./", "dir #{var}/db/redis/"
      s.gsub! "\# bind 127.0.0.1", "bind 127.0.0.1"
    end

    etc.install "redis.conf"
    etc.install "sentinel.conf" => "redis-sentinel.conf"
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
