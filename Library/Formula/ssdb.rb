require 'formula'

class Ssdb < Formula
  homepage "http://ssdb.io/?lang=en"
  url "https://github.com/ideawu/ssdb/archive/1.8.0.tar.gz"
  sha1 "ed9f016bdfef9543a866144fee4a37544f39155e"
  head "https://github.com/ideawu/ssdb.git"

  bottle do
    sha1 "b1a7566fcd83d479a03e7b47be9a68359b36cc77" => :yosemite
    sha1 "b68643eb0c93132b41c8f09fca4005e683db9d73" => :mavericks
    sha1 "99f7b2b71217e236fa6dee657562b3efbf4a9750" => :mountain_lion
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
