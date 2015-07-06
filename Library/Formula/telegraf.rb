require "language/go"

class Telegraf < Formula
  desc "Server-level agent for InfluxDB"
  homepage "https://influxdb.com"
  url "https://github.com/influxdb/telegraf/archive/v0.1.3.tar.gz"
  sha256 "ed719e317e9918b314f92cdca09ab7e34fa12c357800fe31cb1c8978a2128f40"

  bottle do
    cellar :any
    sha256 "6cb91d8c1db1d84ff45dcda761ac5cb5d6da11d652618a1952555dda5869d846" => :yosemite
    sha256 "e145923cd453a2d7ed19a2a5912858b5926d78cc95161dfc6caacd487911d819" => :mavericks
    sha256 "2ced74471933b8877527934828d6c1881c1f306ea8f5d0d5013774b5b721eed1" => :mountain_lion
  end

  depends_on "go" => :build

  go_resource "github.com/influxdb/influxdb" do
    url "https://github.com/influxdb/influxdb.git",
      :revision => "714b47718357b7f8e5a03f0be5c98f15d9169902"
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
      :revision => "dc50b6ad2d3ee836442cf3389009c7cd1e64bb43"
  end

  go_resource "github.com/go-sql-driver/mysql" do
    url "https://github.com/go-sql-driver/mysql.git",
      :revision => "fb7299726d2e68745a8805b14f2ff44b5c2cfa84"
  end

  go_resource "github.com/fsouza/go-dockerclient" do
    url "https://github.com/fsouza/go-dockerclient.git",
      :revision => "35847426976fd56374fded966e1156b5eec6dd60"
  end

  go_resource "github.com/stretchr/testify" do
    url "https://github.com/stretchr/testify.git",
      :revision => "089c7181b8c728499929ff09b62d3fdd8df8adff"
  end

  go_resource "golang.org/x/crypto" do
    url "https://github.com/golang/crypto.git",
      :revision => "2f677ffe0a128ed6d4e3ecb565e4d29a6c6365da"
  end

  go_resource "github.com/stretchr/objx" do
    url "https://github.com/stretchr/objx.git",
      :revision => "cbeaeb16a013161a98496fad62933b1d21786672"
  end

  go_resource "github.com/hashicorp/raft" do
    url "https://github.com/hashicorp/raft.git",
      :revision => "4165b47aca63ce628b65bde39d77b06acf8367ba"
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
      :revision => "f78e6df1618bbffcfc67c1e006a088d834081226"
  end

  go_resource "github.com/gogo/protobuf" do
    url "https://github.com/gogo/protobuf.git",
      :revision => "64f27bf06efee53589314a6e5a4af34cdd85adf6"
  end

  go_resource "github.com/boltdb/bolt" do
    url "https://github.com/boltdb/bolt.git",
      :revision => "04a3e85793043e76d41164037d0d7f9d53eecae3"
  end

  go_resource "github.com/armon/go-metrics" do
    url "https://github.com/armon/go-metrics.git",
      :revision => "b2d95e5291cdbc26997d1301a5e467ecbb240e25"
  end

  go_resource "gopkg.in/dancannon/gorethink.v1" do
    url "https://github.com/dancannon/gorethink.git",
      :revision => "8aca6ba2cc6e873299617d730fac0d7f6593113a"
  end

  go_resource "gopkg.in/Shopify/sarama.v1" do
    url "https://github.com/Shopify/sarama.git",
      :revision => "377669e691f8ba3714f32fc2be1915a0207603a7"
  end

  go_resource "github.com/wvanbergen/kafka" do
    url "https://github.com/wvanbergen/kafka.git",
      :revision => "e236a65a9ca6e56d37a2915dc5dab72ac707a4f6"
  end

  go_resource "github.com/wvanbergen/kazoo-go" do
    url "https://github.com/wvanbergen/kazoo-go.git",
      :revision => "15e8d60fd2c1be5b57071b5bbc0b4479cd162a5f"
  end

  go_resource "github.com/samuel/go-zookeeper" do
    url "https://github.com/samuel/go-zookeeper.git",
      :revision => "5bb5cfc093ad18a28148c578f8632cfdb4d802e4"
  end

  go_resource "github.com/prometheus/client_golang" do
    url "https://github.com/prometheus/client_golang.git",
      :revision => "3b16b46a713f181888e5e9a1205ccc34d6917fb9"
  end

  go_resource "github.com/prometheus/client_model" do
    url "https://github.com/prometheus/client_model.git",
      :revision => "fa8ad6fec33561be4280a8f0514318c79d7f6cb6"
  end

  go_resource "github.com/matttproud/golang_protobuf_extensions" do
    url "https://github.com/matttproud/golang_protobuf_extensions.git",
      :revision => "fc2b8d3a73c4867e51861bbdd5ae3c1f0869dd6a"
  end

  go_resource "github.com/golang/snappy" do
    url "https://github.com/golang/snappy.git",
      :revision => "eaa750b9bf4dcb7cb20454be850613b66cda3273"
  end

  go_resource "github.com/eapache/queue" do
    url "https://github.com/eapache/queue.git",
      :revision => "ded5959c0d4e360646dc9e9908cff48666781367"
  end

  go_resource "github.com/eapache/go-resiliency" do
    url "https://github.com/eapache/go-resiliency.git",
      :revision => "ed0319b32e66e3295db52695ba3ee493e823fbfe"
  end

  def install
    ENV["GOBIN"] = bin
    ENV["GOPATH"] = buildpath
    ENV["GOHOME"] = buildpath

    telegraf_path = buildpath/"src/github.com/influxdb/telegraf"
    telegraf_path.install Dir["*"]

    Language::Go.stage_deps resources, buildpath/"src"

    cd telegraf_path do
      system "go", "build", "-ldflags", "-X main.Version 0.1.3 -X main.Commit 120218f9c6b45bc909c5b9eaa6825d5ace6713be", "cmd/telegraf/telegraf.go"
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
