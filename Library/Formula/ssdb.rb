require 'formula'

class Ssdb < Formula
  homepage "http://ssdb.io/?lang=en"
  url "https://github.com/ideawu/ssdb/archive/1.7.0.1.tar.gz"
  sha1 "90c06e31a5e7c921363ea88d2595d593d42ff607"
  head "https://github.com/ideawu/ssdb.git"

  bottle do
    sha1 "78f7a3a181202a181c7d02a5dc4fda56fee1535b" => :yosemite
    sha1 "dbbee617f78d489526d6c1565013cddc33c53dc1" => :mavericks
    sha1 "ca8048fbf774604109d8344dcf1a099eaa4e9f0e" => :mountain_lion
  end

  def install
    inreplace "Makefile", "PREFIX=/usr/local/ssdb", "PREFIX=#{prefix}"

    system "make", "prefix=#{prefix} CC=#{ENV.cc} CXX=#{ENV.cxx}"
    system "make", "install"

    ["bench", "dump", "ins.sh", "repair", "server"].each do |suffix|
      bin.install "#{prefix}/ssdb-#{suffix}"
    end

    ["run", "db/ssdb", "log"].each do |dir|
      (var+dir).mkpath
    end

    inreplace "ssdb.conf" do |s|
      s.gsub! "work_dir = ./var", "work_dir = #{var}/db/ssdb/"
      s.gsub! "pidfile = ./var/ssdb.pid", "pidfile = #{var}/run/ssdb.pid"
      s.gsub! "\toutput: log.txt", "\toutput: #{var}/log/ssdb.log"
    end

    inreplace "ssdb_slave.conf" do |s|
      s.gsub! "work_dir = ./var_slave", "work_dir = #{var}/db/ssdb/"
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
      Signal.trap("TERM") { system("#{bin}/ssdb-server -d #{HOMEBREW_PREFIX}/etc/ssdb.conf"); exit }
    end
    sleep(3)
    Process.kill("TERM", pid)
  end
end
