require "formula"

class Influxdb < Formula
  homepage "http://influxdb.com"
  url "https://s3.amazonaws.com/get.influxdb.org/influxdb-0.8.7.src.tar.gz"
  sha1 "306faf54878276c374b129fab4afee9556e413cc"

  bottle do
    sha1 "087a8a843e5ecf423efe556278b716f36a8a067f" => :yosemite
    sha1 "eeb291a545fc56938b31d366cf184a3120fad6b4" => :mavericks
    sha1 "9c271c356c66279bd9951ebc9255ade48fa03c32" => :mountain_lion
  end

  depends_on "leveldb"
  depends_on "rocksdb"
  depends_on "autoconf" => :build
  depends_on "protobuf" => :build
  depends_on "bison" => :build
  depends_on "flex" => :build
  depends_on "go" => :build
  depends_on "gawk" => :build
  depends_on :hg => :build

  def install
    ENV["GOPATH"] = buildpath
    Dir.chdir File.join(buildpath, "src", "github.com", "influxdb", "influxdb")

    flex = Formula["flex"].bin/"flex"
    bison = Formula["bison"].bin/"bison"

    inreplace "configure" do |s|
      s.gsub! "echo -n", "$as_echo_n"
    end

    system "./configure", "--with-flex=#{flex}", "--with-bison=#{bison}", "--with-rocksdb"
    system "make", "parser", "protobuf"
    system "go", "build", "-tags", "rocksdb", "-o", "influxdb", "github.com/influxdb/influxdb/daemon"

    inreplace "config.sample.toml" do |s|
      s.gsub! "/tmp/influxdb/development/db", "#{var}/influxdb/data"
      s.gsub! "/tmp/influxdb/development/raft", "#{var}/influxdb/raft"
      s.gsub! "/tmp/influxdb/development/wal", "#{var}/influxdb/wal"
      s.gsub! "influxdb.log", "#{var}/influxdb/logs/influxdb.log"
    end

    bin.install "influxdb" => "influxdb"
    etc.install "config.sample.toml" => "influxdb.conf"

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
