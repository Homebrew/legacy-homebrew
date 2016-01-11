class Ssdb < Formula
  desc "NoSQL database supporting many data structures: Redis alternative"
  homepage "http://ssdb.io/"
  url "https://github.com/ideawu/ssdb/archive/1.9.2.tar.gz"
  sha256 "9387ebeaf24f4e3355967ba2459b59be683f75d6423f408ce4cefed2596b4736"
  head "https://github.com/ideawu/ssdb.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8155bfa1e0c35747998a505072afec2427e66535844a41053463612ca2fb487a" => :el_capitan
    sha256 "a933b076c4db3cf375f4a56c4c92e7e56ac608384d24b538563e1ee2707cdc3a" => :yosemite
    sha256 "d997f3f17d79e1485389eb4f6c86ba6a5dd60f0d690852dfd689d292877bc8f0" => :mavericks
  end

  def install
    inreplace "tools/ssdb-cli", "DIR=`dirname $0`", "DIR=#{prefix}"

    system "make", "CC=#{ENV.cc}", "CXX=#{ENV.cxx}"
    system "make", "install", "PREFIX=#{prefix}"

    inreplace "#{prefix}/ssdb-ins.sh" do |s|
      # Fix path to ssdb-server.
      s.gsub! "/usr/local/ssdb", bin
      # Fix handling of absolute pid path in config.
      s.gsub! "dir=`dirname $config`\n", ""
      s.gsub! %r{\$dir/`(.*?) \| sed -n 's/\^\\.\\///p'`}, '`\1`'
    end

    ["bench", "cli", "dump", "ins.sh", "repair", "server"].each do |suffix|
      bin.install "#{prefix}/ssdb-#{suffix}"
    end

    ["run", "db/ssdb", "db/ssdb_slave", "log"].each do |dir|
      (var/dir).mkpath
    end

    inreplace "ssdb.conf" do |s|
      s.gsub! "work_dir = ./var", "work_dir = #{var}/db/ssdb/"
      s.gsub! "pidfile = ./var/ssdb.pid", "pidfile = #{var}/run/ssdb.pid"
      s.gsub! "\toutput: log.txt", "\toutput: #{var}/log/ssdb.log"
    end

    inreplace "ssdb_slave.conf" do |s|
      s.gsub! "work_dir = ./var_slave", "work_dir = #{var}/db/ssdb_slave/"
      s.gsub! "pidfile = ./var_slave/ssdb.pid", "pidfile = #{var}/run/ssdb_slave.pid"
      s.gsub! "\toutput: log_slave.txt", "\toutput: #{var}/log/ssdb_slave.log"
    end

    etc.install "ssdb.conf"
    etc.install "ssdb_slave.conf"
  end

  plist_options :manual => "ssdb-server #{HOMEBREW_PREFIX}/etc/ssdb.conf"

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
          <string>#{opt_bin}/ssdb-server</string>
          <string>#{etc}/ssdb.conf</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/ssdb.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/ssdb.log</string>
      </dict>
    </plist>
    EOS
  end

  test do
    pid = fork do
      Signal.trap("TERM") do
        system("#{bin}/ssdb-server -d #{HOMEBREW_PREFIX}/etc/ssdb.conf")
        exit
      end
    end
    sleep(3)
    Process.kill("TERM", pid)
  end
end
