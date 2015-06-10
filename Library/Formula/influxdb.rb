require "formula"
require "language/go"

class Influxdb < Formula
  desc "Time series, events, and metrics database"
  homepage "http://influxdb.com"
  url "https://s3.amazonaws.com/get.influxdb.org/influxdb-0.8.8.src.tar.gz"
  sha1 "a5686d0374ec5ab616e335e9c5fb1aeacd17fb00"

  bottle do
    cellar :any
    revision 2
    sha256 "bb246da9efb02f1dfaf3b401b1c6a5058de82081e4c31526228cb5fb486df787" => :yosemite
    sha256 "abb2b857200ce69022981b8a7694f3fe4f24fadf905e3c6c3236a3a0ad946e7a" => :mavericks
    sha256 "b3b3c081494c29f7fc0387d9e746732f3ac0cdaa480e891468b020ad5a3c9ed8" => :mountain_lion
  end

  devel do
    url "https://github.com/influxdb/influxdb/archive/v0.9.0-rc33.tar.gz"
    sha256 "9eed2631309e22b555336ef6358551c4dda1dc407b6240837a61de8c395b4987"
    version "0.9.0-rc33"
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
    go_resource "github.com/BurntSushi/toml" do
      url "https://github.com/BurntSushi/toml.git", :revision => "056c9bc7be7190eaa7715723883caffa5f8fa3e4"
    end

    go_resource "github.com/armon/go-metrics" do
      url "https://github.com/armon/go-metrics.git", :revision => "b2d95e5291cdbc26997d1301a5e467ecbb240e25"
    end

    go_resource "github.com/bmizerany/pat" do
      url "https://github.com/bmizerany/pat.git", :revision => "b8a35001b773c267eb260a691f4e5499a3531600"
    end

    go_resource "github.com/boltdb/bolt" do
      url "https://github.com/boltdb/bolt.git", :revision => "abb4088170cfac644ed5f4648a5cdc566cdb1da2"
    end

    go_resource "github.com/gogo/protobuf" do
      url "https://github.com/gogo/protobuf.git", :revision => "499788908625f4d83de42a204d1350fde8588e4f"
    end

    go_resource "github.com/hashicorp/go-msgpack" do
      url "https://github.com/hashicorp/go-msgpack.git", :revision => "fa3f63826f7c23912c15263591e65d54d080b458"
    end

    go_resource "github.com/hashicorp/raft" do
      url "https://github.com/hashicorp/raft.git", :revision => "379e28eb5a538707eae7a97ecc60846821217f27"
    end

    go_resource "github.com/hashicorp/raft-boltdb" do
      url "https://github.com/hashicorp/raft-boltdb.git", :revision => "d1e82c1ec3f15ee991f7cc7ffd5b67ff6f5bbaee"
    end

    go_resource "github.com/kimor79/gollectd" do
      url "https://github.com/kimor79/gollectd.git", :revision => "cf6dec97343244b5d8a5485463675d42f574aa2d"
    end

    go_resource "github.com/peterh/liner" do
      url "https://github.com/peterh/liner.git", :revision => "1bb0d1c1a25ed393d8feb09bab039b2b1b1fbced"
    end

    go_resource "github.com/rakyll/statik" do
      url "https://github.com/rakyll/statik.git", :revision => "274df120e9065bdd08eb1120e0375e3dc1ae8465"
    end

    go_resource "golang.org/x/crypto" do
      url "https://go.googlesource.com/crypto.git", :revision => "1e856cbfdf9bc25eefca75f83f25d55e35ae72e0"
    end

    go_resource "gopkg.in/fatih/pool.v2" do
      url "https://github.com/fatih/pool.git", :revision => "cba550ebf9bce999a02e963296d4bc7a486cb715"
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
        system "go", "install", "-ldflags", "-X main.version 0.9.0-rc33 -X main.commit 10b07a1bbd0463686ed7713b01a42f1e7a596ec6", "./..."
      end

      inreplace influxdb_path/"etc/config.sample.toml" do |s|
        s.gsub! "/var/opt/influxdb/data", "#{var}/influxdb/data"
        s.gsub! "/var/opt/influxdb/meta", "#{var}/influxdb/meta"
        s.gsub! "/var/opt/influxdb/hh", "#{var}/influxdb/hh"
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
            <string>-config</string>
            <string>#{HOMEBREW_PREFIX}/etc/influxdb.conf</string>
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
