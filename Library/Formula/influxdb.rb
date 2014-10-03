require "formula"

class Influxdb < Formula
  homepage "http://influxdb.org"
  url "http://get.influxdb.org/with_dependencies/influxdb-0.8.3.src.tar.gz"
  sha1 "2626bc5e8877ab23db3b121b64f4c5f9c8a2b627"

  bottle do
    revision 1
    sha1 "ad6e564cde67cb0518416777e5e18ff5796a5380" => :mavericks
    sha1 "b18f89ce07b08020099e15918e7d7e1f909305e0" => :mountain_lion
    sha1 "1d83ccd8902d6fb401b4483c1fe186e8c46e8b45" => :lion
  end

  depends_on "leveldb"
  depends_on "rocksdb"
  depends_on "autoconf" => :build
  depends_on "protobuf" => :build
  depends_on "bison" => :build
  depends_on "flex" => :build
  depends_on "go" => :build
  depends_on "gawk" => :build

  def install
    ENV["GOPATH"] = buildpath.parent
    Dir.chdir File.join(buildpath, "github.com", "influxdb", "influxdb")

    flex = Formula["flex"].bin/"flex"
    bison = Formula["bison"].bin/"bison"

    system "./configure", "--with-flex=#{flex}", "--with-bison=#{bison}"

    system "make", "protobuf"
    system "make", "parser"

    inreplace "daemon/version.go" do |s|
      s.gsub! /^(const version).*$/, %Q{\\1 = "0.8.3"}
      s.gsub! /^(const gitSha).*$/, %Q{\\1 = "fbf9a474055051c64e947f2a071388ee009a08d5"}
    end

    system "go", "build", "-o", "influxdb", "github.com/influxdb/influxdb/daemon"

    inreplace "config.sample.toml" do |s|
      s.gsub! "/tmp/influxdb/development/db", "#{var}/influxdb/data"
      s.gsub! "/tmp/influxdb/development/raft", "#{var}/influxdb/raft"
      s.gsub! "/tmp/influxdb/development/wal", "#{var}/influxdb/wal"
      s.gsub! "influxdb.log", "#{var}/influxdb/logs/influxdb.log"
      s.gsub! "./admin", "#{opt_share}/admin"
    end

    bin.install "influxdb" => "influxdb"
    etc.install "config.sample.toml" => "influxdb.conf"
    share.install "admin-ui" => "admin"

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
