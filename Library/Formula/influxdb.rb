require "formula"

class Influxdb < Formula
  homepage "http://influxdb.org"
  url "http://get.influxdb.org/influxdb-0.6.4.src.tar.gz"
  sha1 "33167a585ee622780e40238c399e2cdab1c930c9"

  bottle do
    sha1 "38ec8cd228d6bb9ba836ffaf6f1d9dba1ffc66c1" => :mavericks
    sha1 "74e0396b8f2f5a2a496014e3b719bcd38d9fab3a" => :mountain_lion
    sha1 "ad94ab3e5c9eb45d1c0d4f0d6cb4944a4fe34b0c" => :lion
  end

  depends_on "leveldb"
  depends_on "protobuf" => :build
  depends_on "bison" => :build
  depends_on "flex" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    flex = Formula["flex"].bin/"flex"
    bison = Formula["bison"].bin/"bison"

    system "./configure", "--with-flex=#{flex}", "--with-bison=#{bison}"
    system "make", "dependencies", "protobuf", "parser"
    system "go", "build", "daemon"

    inreplace "config.sample.toml" do |s|
      s.gsub! "/tmp/influxdb/development/db", "#{var}/influxdb/data"
      s.gsub! "/tmp/influxdb/development/raft", "#{var}/influxdb/raft"
      s.gsub! "/tmp/influxdb/development/wal", "#{var}/influxdb/wal"
      s.gsub! "./admin", "#{opt_share}/admin"
    end

    bin.install "daemon" => "influxdb"
    etc.install "config.sample.toml" => "influxdb.conf"
    share.install "admin"

    (var/"influxdb/data").mkpath
    (var/"influxdb/raft").mkpath
  end

  plist_options :manual => "influxdb -config=#{HOMEBREW_PREFIX}/etc/influxdb.conf"

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
          <string>#{opt_bin}/influxdb</string>
          <string>-config=#{etc}/influxdb.conf</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/influxdb.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/influxdb.log</string>
      </dict>
    </plist>
    EOS
  end

  test do
    system "#{bin}/influxdb", "-v"
  end
end
