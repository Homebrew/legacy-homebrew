require "language/go"

class Influxdb < Formula
  desc "Time series, events, and metrics database"
  homepage "http://influxdb.com"

  stable do
    url "https://github.com/influxdb/influxdb/archive/v0.9.0.tar.gz"
    sha256 "c7cc869754d7bfb9374b0a16a9b91073d9588adedbd7bfda1d5709e22d3a3d75"
  end

  bottle do
    cellar :any
    revision 1
    sha256 "357b0d2a3a71d4451e887e85fda7f2d79d4ab7cae4f7d8de62f6102f55986402" => :yosemite
    sha256 "14619d7bce3788b295910f08a48377f74e2efc54d4f1c0c22d79f07a74022523" => :mavericks
    sha256 "b07a2a1ca26c32cc8b6b0fa8d00f735066c10cdc27ebd3e132eceae17fa96129" => :mountain_lion
  end

  head do
    url "https://github.com/influxdb/influxdb.git"

    go_resource "collectd.org" do
      url "https://github.com/collectd/go-collectd.git", :revision => "27f4f77337ae0b2de0d3267f6278d62aff8b52fb"
    end
  end

  depends_on "go" => :build

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

  go_resource "github.com/golang/protobuf" do
    url "https://github.com/golang/protobuf.git", :revision => "34a5f244f1c01cdfee8e60324258cfbb97a42aec"
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

  def install
    ENV["GOPATH"] = buildpath
    influxdb_path = buildpath/"src/github.com/influxdb/influxdb"
    influxdb_path.install Dir["*"]

    Language::Go.stage_deps resources, buildpath/"src"

    cd influxdb_path do
      if build.head?
        system "go", "install", "-ldflags", "-X main.version 0.9.0-HEAD -X main.commit #{`git rev-parse HEAD`.strip}", "./..."
      else
        system "go", "install", "-ldflags", "-X main.version 0.9.0 -X main.commit 471117ce5b308e59f8f247d8a88a52ead553b602", "./..."
      end
    end

    inreplace influxdb_path/"etc/config.sample.toml" do |s|
      s.gsub! "/var/opt/influxdb/data", "#{var}/influxdb/data"
      s.gsub! "/var/opt/influxdb/meta", "#{var}/influxdb/meta"
      s.gsub! "/var/opt/influxdb/hh", "#{var}/influxdb/hh"
    end

    bin.install buildpath/"bin/influxd"
    bin.install buildpath/"bin/influx"
    etc.install influxdb_path/"etc/config.sample.toml" => "influxdb.conf"

    (var/"influxdb/data").mkpath
    (var/"influxdb/meta").mkpath
    (var/"influxdb/hh").mkpath
  end

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

  def caveats; <<-EOS.undent
    Config files from old InfluxDB versions are incompatible with version 0.9.
    If upgrading from a pre-0.9 version, the new configuration file will be named:
        #{etc}/influxdb.conf.default
    To generate a new config file:
        influxd config > influxdb.conf.generated
    EOS
  end
end
