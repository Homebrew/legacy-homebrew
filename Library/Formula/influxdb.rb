require "formula"

class Influxdb < Formula
  homepage "http://influxdb.org"
  url "http://get.influxdb.org/src/influxdb-0.3.0.tar.gz"
  sha1 "057e5ac9a53f1c516f920d9f5c158b4998f669c6"

  bottle do
    sha1 'b9bd4fb3404f11457522db197d47862e354848a5' => :mavericks
    sha1 '0baf4e253800bf95524ddd5bae79f54e66dcf18e' => :mountain_lion
    sha1 'b3c0a6b7e668c57e78f92d13a3f89e9dc4c1d1da' => :lion
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

    (var/'influxdb/data').mkpath
    (var/'influxdb/raft').mkpath
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
