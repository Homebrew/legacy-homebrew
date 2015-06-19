require "language/go"

class Telegraf < Formula
  desc "Server-level agent for InfluxDB"
  homepage "https://influxdb.com"
  url "https://github.com/influxdb/telegraf/archive/v0.1.1.tar.gz"
  sha256 "75b6e22b0c8d385ca28fe82dfb730d60cc3c8522fe705828739ebedba89bc8b6"

  bottle do
    cellar :any
    sha256 "2b896c58657d04f38ad064c8170774e7197d15180551f9146abfaac2938b1e30" => :yosemite
    sha256 "2284cdc4e38637a04dbac77720356f8482c6a0628cdfc18d31d64e7a1df9bcdd" => :mavericks
    sha256 "34c10a8234aba02a58c96670a21ce13dd581bd8e1506fa39082a42a6e34cfd1e" => :mountain_lion
  end

  depends_on "go" => :build

  go_resource "github.com/influxdb/influxdb" do
    url "https://github.com/influxdb/influxdb.git",
      :revision => "9f45a9eea3017e372711d3ae5949056d53a4ba6a"
  end

  go_resource "github.com/naoina/toml" do
    url "https://github.com/naoina/toml.git",
      :revision => "5667c316ee9576e9d5bca793ce4ec813a88ce7d3"
  end

  go_resource "github.com/naoina/go-stringutil" do
    url "https://github.com/naoina/go-stringutil.git",
      :revision => "360db0db4b01d34e12a2ec042c09e7d37fece761"
  end

  go_resource "github.com/lib/pq" do
    url "https://github.com/lib/pq.git",
      :revision => "a8d8d01c4f91602f876bf5aa210274e8203a6b45"
  end

  go_resource "github.com/go-sql-driver/mysql" do
    url "https://github.com/go-sql-driver/mysql.git",
      :revision => "66b7d5c4956096efd4c945494d64ad73f1d9ec39"
  end

  go_resource "github.com/fsouza/go-dockerclient" do
    url "https://github.com/fsouza/go-dockerclient.git",
      :revision => "af4d4292dfcb9ebc8052c5d63bdaaa2343801f20"
  end

  go_resource "github.com/stretchr/testify" do
    url "https://github.com/stretchr/testify.git",
      :revision => "ddcad49ec6b8f31bc3daf3a1fbea7eac58d61ff0"
  end

  go_resource "golang.org/x/crypto" do
    url "https://github.com/golang/crypto.git",
      :revision => "1e856cbfdf9bc25eefca75f83f25d55e35ae72e0"
  end

  go_resource "github.com/stretchr/objx" do
    url "https://github.com/stretchr/objx.git",
      :revision => "cbeaeb16a013161a98496fad62933b1d21786672"
  end

  go_resource "github.com/hashicorp/raft" do
    url "https://github.com/hashicorp/raft.git",
      :revision => "379e28eb5a538707eae7a97ecc60846821217f27"
  end

  go_resource "github.com/hashicorp/raft-boltdb" do
    url "https://github.com/hashicorp/raft-boltdb.git",
      :revision => "d1e82c1ec3f15ee991f7cc7ffd5b67ff6f5bbaee"
  end

  go_resource "github.com/hashicorp/go-msgpack" do
    url "https://github.com/hashicorp/go-msgpack.git",
      :revision => "fa3f63826f7c23912c15263591e65d54d080b458"
  end

  go_resource "github.com/golang/protobuf" do
    url "https://github.com/golang/protobuf.git",
      :revision => "aece6fb931241ad332956db4f62798dfbea944b3"
  end

  go_resource "github.com/gogo/protobuf" do
    url "https://github.com/gogo/protobuf.git",
      :revision => "05b9dd05e2149cf01fd645b3dc550542556ddea7"
  end

  go_resource "github.com/boltdb/bolt" do
    url "https://github.com/boltdb/bolt.git",
      :revision => "04a3e85793043e76d41164037d0d7f9d53eecae3"
  end

  go_resource "github.com/armon/go-metrics" do
    url "https://github.com/armon/go-metrics.git",
      :revision => "b2d95e5291cdbc26997d1301a5e467ecbb240e25"
  end

  def install
    ENV["GOBIN"] = bin
    ENV["GOPATH"] = buildpath
    ENV["GOHOME"] = buildpath

    telegraf_path = buildpath/"src/github.com/influxdb/telegraf"
    telegraf_path.install Dir["*"]

    Language::Go.stage_deps resources, buildpath/"src"

    cd telegraf_path do
      system "go", "build", "-ldflags", "-X main.Version 0.1.1 -X main.Commit 39c90dd879ce51da60102e9f5694474933607c8f", "cmd/telegraf/telegraf.go"
    end

    bin.install telegraf_path/"telegraf"
    etc.install telegraf_path/"etc/config.sample.toml" => "telegraf.conf"
  end

  plist_options :manual => "telegraf -config #{HOMEBREW_PREFIX}/etc/telegraf.conf"

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
          <string>#{opt_bin}/telegraf</string>
          <string>-config</string>
          <string>#{HOMEBREW_PREFIX}/etc/telegraf.conf</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/telegraf.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/telegraf.log</string>
      </dict>
    </plist>
    EOS
  end

  test do
    assert_match /InfluxDB Telegraf/, shell_output("telegraf -version")
    assert_match /localhost:8086/, shell_output("telegraf -sample-config")
  end
end
