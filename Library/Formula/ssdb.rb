class Ssdb < Formula
  desc "NoSQL database supporting many data structures: Redis alternative"
  homepage "http://ssdb.io/"
  url "https://github.com/ideawu/ssdb/archive/1.8.2.tar.gz"
  sha256 "2fe10689a0e1e9e9ca67acbe9e0fa3607810dca90dcc9f0813b2661cc6d4e826"
  head "https://github.com/ideawu/ssdb.git"

  bottle do
    cellar :any
    sha256 "1970e505fd1e8f6166010a892e66a718a39cbab1bcdd515bd6fdd4ec7c185600" => :yosemite
    sha256 "61430871ab15a312f8a6b0caf68003d379fc8e52199702747b84f86f3887d911" => :mavericks
    sha256 "16b3c20d79519328e01139ccf8fc71832f90d5df1c55c9ba32ab150a0cddf77e" => :mountain_lion
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
      Signal.trap("TERM") do
        system("#{bin}/ssdb-server -d #{HOMEBREW_PREFIX}/etc/ssdb.conf")
        exit
      end
    end
    sleep(3)
    Process.kill("TERM", pid)
  end
end
