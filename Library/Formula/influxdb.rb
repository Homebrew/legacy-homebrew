require "language/go"

class Influxdb < Formula
  desc "Time series, events, and metrics database"
  homepage "https://influxdb.com"

  stable do
    url "https://github.com/influxdb/influxdb/archive/v0.9.3.tar.gz"
    sha256 "f49f7a007f821991984dd8716a6ddccc94a1832c5ac1abf4bb1cb88d9616c2e9"
  end

  bottle do
    cellar :any
    sha256 "5e79b7fd8a73044b8bfe3c42bcc5146ea11ec7bbd9d3f888432faf3d761d4abe" => :yosemite
    sha256 "adc114f9abc40db4b9672a37d4f9fc9ebd7c8e1767db8cc6c204767aa694732b" => :mavericks
    sha256 "3136f678fb48e5040be3c242211bc40ce4de411947aa740fd674242f12a2ceee" => :mountain_lion
  end

  head do
    url "https://github.com/influxdb/influxdb.git"
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
    url "https://github.com/boltdb/bolt.git", :revision => "0f053fabc06119583d61937a0a06ef0ba0f1b301"
  end

  go_resource "github.com/gogo/protobuf" do
    url "https://github.com/gogo/protobuf.git", :revision => "cabd153b69f71bab8b89fd667a2d9bb28c92ceb4"
  end

  go_resource "github.com/golang/protobuf" do
    url "https://github.com/golang/protobuf.git", :revision => "aece6fb931241ad332956db4f62798dfbea944b3"
  end

  go_resource "github.com/hashicorp/go-msgpack" do
    url "https://github.com/hashicorp/go-msgpack.git", :revision => "fa3f63826f7c23912c15263591e65d54d080b458"
  end

  go_resource "github.com/hashicorp/raft" do
    url "https://github.com/hashicorp/raft.git", :revision => "feb5f8bb5624ccb475c1354a2ca14a22eea7da4e"
  end

  go_resource "github.com/hashicorp/raft-boltdb" do
    url "https://github.com/hashicorp/raft-boltdb.git", :revision => "d1e82c1ec3f15ee991f7cc7ffd5b67ff6f5bbaee"
  end

  go_resource "github.com/kimor79/gollectd" do
    url "https://github.com/kimor79/gollectd.git", :revision => "61d0deeb4ffcc167b2a1baa8efd72365692811bc"
  end

  go_resource "github.com/peterh/liner" do
    url "https://github.com/peterh/liner.git", :revision => "c754da6f2d91ef30ddb6c975d2dbe7696eec4fbc"
  end

  go_resource "github.com/rakyll/statik" do
    url "https://github.com/rakyll/statik.git", :revision => "274df120e9065bdd08eb1120e0375e3dc1ae8465"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git", :revision => "81bf7719a6b7ce9b665598222362b50122dfc13b"
  end

  go_resource "gopkg.in/fatih/pool.v2" do
    url "https://github.com/fatih/pool.git", :revision => "cba550ebf9bce999a02e963296d4bc7a486cb715"
  end

  go_resource "collectd.org" do
    url "https://github.com/collectd/go-collectd.git", :revision => "b57a70fc3a8592302821687ba82204ba4071b0a8"
  end

  go_resource "github.com/golang/snappy" do
    url "https://github.com/golang/snappy.git", :revision => "723cc1e459b8eea2dea4583200fd60757d40097a"
  end

  def install
    ENV["GOPATH"] = buildpath
    influxdb_path = buildpath/"src/github.com/influxdb/influxdb"
    influxdb_path.install Dir["*"]

    Language::Go.stage_deps resources, buildpath/"src"

    cd influxdb_path do
      if build.head?
        system "go", "install", "-ldflags", "-X main.version 0.9.4-HEAD -X main.commit #{`git rev-parse HEAD`.strip}", "./..."
      else
        system "go", "install", "-ldflags", "-X main.version 0.9.3 -X main.commit 2094f3fec17e7f675e5cacc8e984d98b1aec662d", "./..."
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
