require "language/go"

class Influxdb < Formula
  desc "Time series, events, and metrics database"
  homepage "https://influxdb.com"
  url "https://github.com/influxdb/influxdb/archive/v0.9.4.2.tar.gz"
  sha256 "aaea27228d7f242fe37d436506592189081beda0e7d2fba3f82c6b233fd913bc"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "baafea68d99c6b061a82dd61d6844354c6c2b2c6eb125570ddde18c402040819" => :el_capitan
    sha256 "008abd90ff91ad469a83e967dbddfa0cb94a98e602341c8edb813a9ba03ef59c" => :yosemite
    sha256 "61fa32294aab823c4f53245d3a5e2d8022923b75c5bd391668b98ee66476ec9c" => :mavericks
  end

  head do
    url "https://github.com/influxdb/influxdb.git"

    go_resource "github.com/dgryski/go-bitstream" do
      url "https://github.com/dgryski/go-bitstream.git", :revision => "8c62433445abdcf8c50094b3d67a15f728d8292b"
    end

    go_resource "github.com/dgryski/go-bits" do
      url "https://github.com/dgryski/go-bits.git", :revision => "2c7641e7dfe3945a0fe755f58c85ab306624956d"
    end

    go_resource "github.com/jwilder/encoding" do
      url "https://github.com/jwilder/encoding.git", :revision => "07d88d4f35eec497617bee0c7bfe651a796dae13"
    end
  end

  depends_on "go" => :build

  go_resource "github.com/BurntSushi/toml" do
    url "https://github.com/BurntSushi/toml.git", :revision => "056c9bc7be7190eaa7715723883caffa5f8fa3e4"
  end

  go_resource "github.com/armon/go-metrics" do
    url "https://github.com/armon/go-metrics.git", :revision => "6c5fa0d8f48f4661c9ba8709799c88d425ad20f0"
  end

  go_resource "github.com/bmizerany/pat" do
    url "https://github.com/bmizerany/pat.git", :revision => "b8a35001b773c267eb260a691f4e5499a3531600"
  end

  go_resource "github.com/boltdb/bolt" do
    url "https://github.com/boltdb/bolt.git", :revision => "51f99c862475898df9773747d3accd05a7ca33c1"
  end

  go_resource "github.com/gogo/protobuf" do
    url "https://github.com/gogo/protobuf.git", :revision => "200875106f3bf0eb01eb297dae30b250a25ffc84"
  end

  go_resource "github.com/golang/protobuf" do
    url "https://github.com/golang/protobuf.git", :revision => "3d2510a4dd961caffa2ae781669c628d82db700a"
  end

  go_resource "github.com/hashicorp/go-msgpack" do
    url "https://github.com/hashicorp/go-msgpack.git", :revision => "fa3f63826f7c23912c15263591e65d54d080b458"
  end

  go_resource "github.com/hashicorp/raft" do
    url "https://github.com/hashicorp/raft.git", :revision => "9dabbbab966c04a0b6efed3cff6960299fed0642"
  end

  go_resource "github.com/hashicorp/raft-boltdb" do
    url "https://github.com/hashicorp/raft-boltdb.git", :revision => "d1e82c1ec3f15ee991f7cc7ffd5b67ff6f5bbaee"
  end

  go_resource "github.com/kimor79/gollectd" do
    url "https://github.com/kimor79/gollectd.git", :revision => "61d0deeb4ffcc167b2a1baa8efd72365692811bc"
  end

  go_resource "github.com/peterh/liner" do
    url "https://github.com/peterh/liner.git", :revision => "b850cf8c6d0ee52309aad09ac610508c6c75e819"
  end

  go_resource "github.com/rakyll/statik" do
    url "https://github.com/rakyll/statik.git", :revision => "274df120e9065bdd08eb1120e0375e3dc1ae8465"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git", :revision => "c8b9e6388ef638d5a8a9d865c634befdc46a6784"
  end

  go_resource "gopkg.in/fatih/pool.v2" do
    url "https://github.com/fatih/pool.git", :revision => "cba550ebf9bce999a02e963296d4bc7a486cb715"
  end

  go_resource "collectd.org" do
    url "https://github.com/collectd/go-collectd.git", :revision => "9fc824c70f713ea0f058a07b49a4c563ef2a3b98"
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
        system "go", "install", "-ldflags", "-X main.version 0.9.5-HEAD -X main.branch master -X main.commit #{`git rev-parse HEAD`.strip}", "./..."
      else
        system "go", "install", "-ldflags", "-X main.version 0.9.4.1 -X main.branch 0.9.4 -X main.commit c4f85f84765e27bfb5e58630d0dea38adeacf543", "./..."
      end
    end

    inreplace influxdb_path/"etc/config.sample.toml" do |s|
      s.gsub! "/var/opt/influxdb/data", "#{var}/influxdb/data"
      s.gsub! "/var/opt/influxdb/meta", "#{var}/influxdb/meta"
      s.gsub! "/var/opt/influxdb/hh", "#{var}/influxdb/hh"
      s.gsub! "/var/opt/influxdb/wal", "#{var}/influxdb/wal"
    end

    bin.install buildpath/"bin/influxd"
    bin.install buildpath/"bin/influx"
    etc.install influxdb_path/"etc/config.sample.toml" => "influxdb.conf"

    (var/"influxdb/data").mkpath
    (var/"influxdb/meta").mkpath
    (var/"influxdb/hh").mkpath
    (var/"influxdb/wal").mkpath
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
        <key>SoftResourceLimits</key>
        <dict>
          <key>NumberOfFiles</key>
          <integer>10240</integer>
        </dict>
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
