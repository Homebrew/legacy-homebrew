require "formula"
require "language/go"

class Influxdb < Formula
  homepage "http://influxdb.com"
  url "https://s3.amazonaws.com/get.influxdb.org/influxdb-0.8.8.src.tar.gz"
  sha1 "a5686d0374ec5ab616e335e9c5fb1aeacd17fb00"

  bottle do
    revision 1
    sha1 "5ef1d6ea8124f7047a818bf3a50830ce6d3d8098" => :yosemite
    sha1 "c6ee43baa6927de07578ac9e20afa5bb9b39fba1" => :mavericks
    sha1 "d8e036216607ffd611fe21bdaeb642462f024b38" => :mountain_lion
  end

  devel do
    url "https://github.com/influxdb/influxdb/archive/v0.9.0-rc14.tar.gz"
    sha1 "054b81cacf9335006e07556f657212784e495f6d"
    version "0.9.0-rc14"
  end

  depends_on "go" => :build
  depends_on :hg => :build

  if build.stable?
    depends_on "leveldb"
    depends_on "rocksdb"
    depends_on "autoconf" => :build
    depends_on "protobuf" => :build
    depends_on "bison" => :build
    depends_on "flex" => :build
    depends_on "gawk" => :build
  else
    go_resource "github.com/bmizerany/pat" do
      url "https://github.com/bmizerany/pat.git", :revision => "b8a35001b773c267eb260a691f4e5499a3531600"
    end

    go_resource "github.com/boltdb/bolt" do
      url "https://github.com/boltdb/bolt.git", :revision => "a7d19d8cd50cb700babad58d0643a4bb6ac8f36c"
    end

    go_resource "github.com/BurntSushi/toml" do
      url "https://github.com/BurntSushi/toml.git", :revision => "443a628bc233f634a75bcbdd71fe5350789f1afa"
    end

    go_resource "github.com/kimor79/gollectd" do
      url "https://github.com/kimor79/gollectd.git", :revision => "1d0fc88b7c2bf0ba79021ddca2b5f5fd9cc3a5a3"
    end

    go_resource "github.com/peterh/liner" do
      url "https://github.com/peterh/liner.git", :revision => "d9335eee40a45a4f5d74524c90040d6fe6013d50"
    end

    go_resource "github.com/rakyll/statik" do
      url "https://github.com/rakyll/statik.git", :revision => "4a16c831de16fd27a38fab90ade0cf35844a31db"
    end

    go_resource "golang.org/x/crypto" do
      url "https://go.googlesource.com/crypto.git", :revision => "1351f936d976c60a0a48d728281922cf63eafb8d"
    end

    go_resource "code.google.com/p/go-uuid" do
      url "https://code.google.com/p/go-uuid/", :revision => "35bc42037350", :using => :hg
    end
  end

  def install
    if build.stable?
      ENV["GOPATH"] = buildpath
      Dir.chdir File.join(buildpath, "src", "github.com", "influxdb", "influxdb")

      flex = Formula["flex"].bin/"flex"
      bison = Formula["bison"].bin/"bison"

      inreplace "configure" do |s|
        s.gsub! "echo -n", "$as_echo_n"
      end

      system "./configure", "--with-flex=#{flex}", "--with-bison=#{bison}", "--with-rocksdb"
      system "make", "parser", "protobuf"
      system "go", "build", "-tags", "leveldb rocksdb", "-o", "influxdb", "github.com/influxdb/influxdb/daemon"

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
    else
      ENV["GOPATH"] = buildpath
      influxdb_path = buildpath/"src/github.com/influxdb/influxdb"
      influxdb_path.install Dir["*"]

      Language::Go.stage_deps resources, buildpath/"src"

      cd influxdb_path do
        system "go", "build", "-ldflags", "-X main.version 0.9.0-rc14 -X main.commit 09fd15f8711f0d74dc27de33625e3882adb55d26", "./..."
        system "go", "install", "./..."
      end

      inreplace influxdb_path/"etc/config.sample.toml" do |s|
        s.gsub! "/tmp/influxdb/development/db", "#{var}/influxdb/data"
        s.gsub! "/tmp/influxdb/development/raft", "#{var}/influxdb/raft"
        s.gsub! "/tmp/influxdb/development/state", "#{var}/influxdb/state"
        s.gsub! "/var/log/influxdb/influxd.log", "#{var}/influxdb/logs/influxd.log"
      end

      bin.install buildpath/"bin/influxd" => "influxd"
      bin.install buildpath/"bin/influx" => "influx"
      etc.install influxdb_path/"etc/config.sample.toml" => "influxdb.conf"

      (var/"influxdb/data").mkpath
      (var/"influxdb/raft").mkpath
      (var/"influxdb/state").mkpath
      (var/"influxdb/logs").mkpath
    end
  end

  if build.stable?
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
            <string>-config=#{HOMEBREW_PREFIX}/etc/influxdb.conf</string>
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
  else
    plist_options :manual => "influxd -config #{HOMEBREW_PREFIX}/etc/influxdb.conf"

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
            <string>#{opt_bin}/influxd</string>
            <string>-config #{HOMEBREW_PREFIX}/etc/influxdb.conf</string>
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
  end
end
