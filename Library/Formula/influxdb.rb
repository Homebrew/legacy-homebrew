require "formula"

class Influxdb < Formula
  homepage "http://influxdb.org"
  url "http://get.influxdb.org/influxdb-0.4.0.src.tar.gz"
  sha1 "102f44c19f0b202205109b871f09ecdbadb38403"

  bottle do
    sha1 "12101de682f664f213c1cbc8703789df0ba0648b" => :mavericks
    sha1 "1e6aab431a126a07accddfd391aa77cab9208067" => :mountain_lion
    sha1 "afb43b10959c140411ce75d051aa0635dd3aaaf5" => :lion
  end

  depends_on "leveldb"
  depends_on "protobuf" => :build
  depends_on "bison" => :build
  depends_on "flex" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    flex = Formula.factory("flex").bin/"flex"
    bison = Formula.factory("bison").bin/"bison"

    system "./configure", "--with-flex=#{flex}", "--with-bison=#{bison}"
    system "make", "dependencies", "protobuf", "parser"
    system "go", "build", "daemon"

    inreplace "config.toml.sample" do |s|
      s.gsub! "/tmp/influxdb/development/db", "#{var}/influxdb/data"
      s.gsub! "/tmp/influxdb/development/raft", "#{var}/influxdb/raft"
      s.gsub! "./admin", "#{opt_prefix}/share/admin"
    end

    bin.install "daemon" => "influxdb"
    etc.install "config.toml.sample" => "influxdb.conf"
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
    system "#{bin}/influxdb", "-v"
  end
end
