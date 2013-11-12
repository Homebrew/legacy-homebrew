require "formula"

class Influxdb < Formula
  homepage "http://influxdb.org"
  url "http://get.influxdb.org/src/influxdb-0.1.0.tar.gz"
  sha1 "97b7a8f36597403e34b918744c60ce0398a2fffb"

  bottle do
    sha1 '2cafb68bd52cf47adf03e1e42551342d0cbfe5cc' => :mavericks
    sha1 '98ef180c3577da468cba3843ff4608a3c6987746' => :mountain_lion
    sha1 'f59872ca4c0b77657e5adfe8c0c02a2b170f322b' => :lion
  end

  depends_on "leveldb"
  depends_on "protobuf" => :build
  depends_on "bison" => :build
  depends_on "flex" => :build
  depends_on "go" => :build

  fails_with :clang do
    cause "clang: error: argument unused during compilation: '-fno-eliminate-unused-debug-types'"
  end

  def install
    ENV["GOPATH"] = buildpath

    system "go build src/server/server.go"

    inreplace "config.json.sample" do |s|
      s.gsub! "/tmp/influxdb/development/db", "#{var}/influxdb/data"
      s.gsub! "/tmp/influxdb/development/raft", "#{var}/influxdb/raft"
      s.gsub! "./admin/", "#{share}/admin/"
    end

    bin.install "server" => "influxdb"
    etc.install "config.json.sample" => "influxdb.conf"
    share.install "admin"

    %w[influxdb influxdb/data influxdb/raft].each { |p| (var+p).mkpath }
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
          <string>#{opt_prefix}/bin/influxdb</string>
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
    system "#{bin}/influxdb -v"
  end
end
