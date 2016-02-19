require "language/go"

class Influxdb < Formula
  desc "Time series, events, and metrics database"
  homepage "https://influxdata.com/time-series-platform/influxdb/"
  url "https://github.com/influxdata/influxdb/archive/v0.10.1.tar.gz"
  sha256 "6a66373006a249cb6ab2a2f33b924694486ee07b1d9096c3f770376d0351b703"

  bottle do
    cellar :any_skip_relocation
    sha256 "4ea28e218a7805755ac516094c691f3799257f182abc06c86f6eb5caf1702d6e" => :el_capitan
    sha256 "0ed3eec3c34d166e063375e4583ca4b9c16fb345d72f60e122749a1c057cb052" => :yosemite
    sha256 "eff6e107c1e1ad6272464771945855d08c9bf700bafafbabd25f9e90a918a380" => :mavericks
  end

  head do
    url "https://github.com/influxdata/influxdb.git"

    go_resource "github.com/influxdata/usage-client" do
      url "https://github.com/influxdata/usage-client.git",
      :revision => "475977e68d79883d9c8d67131c84e4241523f452"
    end
  end

  head do
    url "https://github.com/influxdata/influxdb.git"

    go_resource "github.com/influxdata/usage-client" do
      url "https://github.com/influxdata/usage-client.git",
      :revision => "475977e68d79883d9c8d67131c84e4241523f452"
    end
  end

  depends_on "go" => :build

  go_resource "collectd.org" do
    url "https://github.com/collectd/go-collectd.git",
    :revision => "9fc824c70f713ea0f058a07b49a4c563ef2a3b98"
  end

  go_resource "github.com/BurntSushi/toml" do
    url "https://github.com/BurntSushi/toml.git",
    :revision => "312db06c6c6dbfa9899e58564bacfaa584f18ab7"
  end

  go_resource "github.com/armon/go-metrics" do
    url "https://github.com/armon/go-metrics.git",
    :revision => "345426c77237ece5dab0e1605c3e4b35c3f54757"
  end

  go_resource "github.com/bmizerany/pat" do
    url "https://github.com/bmizerany/pat.git",
    :revision => "c068ca2f0aacee5ac3681d68e4d0a003b7d1fd2c"
  end

  go_resource "github.com/boltdb/bolt" do
    url "https://github.com/boltdb/bolt.git",
    :revision => "2f846c3551b76d7710f159be840d66c3d064abbe"
  end

  go_resource "github.com/davecgh/go-spew" do
    url "https://github.com/davecgh/go-spew.git",
    :revision => "5215b55f46b2b919f50a1df0eaa5886afe4e3b3d"
  end

  go_resource "github.com/dgryski/go-bits" do
    url "https://github.com/dgryski/go-bits.git",
    :revision => "86c69b3c986f9d40065df5bd8f765796549eef2e"
  end

  go_resource "github.com/dgryski/go-bitstream" do
    url "https://github.com/dgryski/go-bitstream.git",
    :revision => "27cd5973303fde7d914860be1ea4b927a6be0c92"
  end

  go_resource "github.com/gogo/protobuf" do
    url "https://github.com/gogo/protobuf.git",
    :revision => "82d16f734d6d871204a3feb1a73cb220cc92574c"
  end

  go_resource "github.com/golang/snappy" do
    url "https://github.com/golang/snappy.git",
    :revision => "d1d908a252c22fd7afd36190d5cffb144aa8f777"
  end

  go_resource "github.com/hashicorp/go-msgpack" do
    url "https://github.com/hashicorp/go-msgpack.git",
    :revision => "fa3f63826f7c23912c15263591e65d54d080b458"
  end

  go_resource "github.com/hashicorp/raft" do
    url "https://github.com/hashicorp/raft.git",
    :revision => "057b893fd996696719e98b6c44649ea14968c811"
  end

  go_resource "github.com/hashicorp/raft-boltdb" do
    url "https://github.com/hashicorp/raft-boltdb.git",
    :revision => "d1e82c1ec3f15ee991f7cc7ffd5b67ff6f5bbaee"
  end

  go_resource "github.com/influxdb/usage-client" do
    url "https://github.com/influxdb/usage-client.git",
    :revision => "475977e68d79883d9c8d67131c84e4241523f452"
  end

  go_resource "github.com/jwilder/encoding" do
    url "https://github.com/jwilder/encoding.git",
    :revision => "07d88d4f35eec497617bee0c7bfe651a796dae13"
  end

  go_resource "github.com/kimor79/gollectd" do
    url "https://github.com/kimor79/gollectd.git",
    :revision => "61d0deeb4ffcc167b2a1baa8efd72365692811bc"
  end

  go_resource "github.com/paulbellamy/ratecounter" do
    url "https://github.com/paulbellamy/ratecounter.git",
    :revision => "5a11f585a31379765c190c033b6ad39956584447"
  end

  go_resource "github.com/peterh/liner" do
    url "https://github.com/peterh/liner.git",
    :revision => "ad1edfd30321d8f006ccf05f1e0524adeb943060"
  end

  go_resource "github.com/rakyll/statik" do
    url "https://github.com/rakyll/statik.git",
    :revision => "274df120e9065bdd08eb1120e0375e3dc1ae8465"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
    :revision => "1f22c0103821b9390939b6776727195525381532"
  end

  go_resource "gopkg.in/fatih/pool.v2" do
    url "https://gopkg.in/fatih/pool.v2.git",
    :revision => "cba550ebf9bce999a02e963296d4bc7a486cb715"
  end

  def install
    ENV["GOPATH"] = buildpath
    if build.head?
      influxdb_path = buildpath/"src/github.com/influxdata/influxdb"
    else
      influxdb_path = buildpath/"src/github.com/influxdb/influxdb"
    end
    influxdb_path.install Dir["*"]

    Language::Go.stage_deps resources, buildpath/"src"

    cd influxdb_path do
      if build.head?
        system "go", "install", "-ldflags", "-X main.version=0.11.0-HEAD -X main.branch=master -X main.commit=#{`git rev-parse HEAD`.strip}", "./..."
      else
        system "go", "install", "-ldflags", "-X main.version=0.10.1 -X main.branch=0.10.0 -X main.commit=b8bb32ecad9808ef00219e7d2469514890a0987a", "./..."
      end
    end

    inreplace influxdb_path/"etc/config.sample.toml" do |s|
      s.gsub! "/var/lib/influxdb/data", "#{var}/influxdb/data"
      s.gsub! "/var/lib/influxdb/meta", "#{var}/influxdb/meta"
      s.gsub! "/var/lib/influxdb/hh", "#{var}/influxdb/hh"
      s.gsub! "/var/lib/influxdb/wal", "#{var}/influxdb/wal"
    end

    bin.install "bin/influxd"
    bin.install "bin/influx"
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

  test do
    (testpath/"config.toml").write shell_output("influxd config")
    inreplace testpath/"config.toml" do |s|
      s.gsub! %r{/.*/.influxdb/data}, "#{testpath}/influxdb/data"
      s.gsub! %r{/.*/.influxdb/meta}, "#{testpath}/influxdb/meta"
      s.gsub! %r{/.*/.influxdb/hh}, "#{testpath}/influxdb/hh"
      s.gsub! %r{/.*/.influxdb/wal}, "#{testpath}/influxdb/wal"
    end

    pid = fork do
      exec "#{bin}/influxd -config #{testpath}/config.toml"
    end
    sleep 5

    begin
      output = shell_output("curl -Is localhost:8086/ping")
      sleep 2
      assert_match /X-Influxdb-Version:/, output
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
