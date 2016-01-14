require "language/go"

class Telegraf < Formula
  desc "Server-level metric gathering agent for InfluxDB"
  homepage "https://influxdb.com"
  url "https://github.com/influxdb/telegraf/archive/v0.2.4.tar.gz"
  sha256 "5cea3a3133822d40e33fafb1f3c91036d1b8ec3a02d920fd4990a92774112179"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "0424c52f259d49e60605fb72f06f723798bc3326d0d745f2b899bbfccf0a8eec" => :el_capitan
    sha256 "0070800d847e9184c827be80de33d85865ae04bafaf302092d53e2aea4aa0aed" => :yosemite
    sha256 "03cca164b756583e5e6f7de72a5e284d274085fbba529b0cdfbc1cbfc828c7a9" => :mavericks
  end

  depends_on "go" => :build

  go_resource "git.eclipse.org/gitroot/paho/org.eclipse.paho.mqtt.golang.git" do
    url "git://git.eclipse.org/gitroot/paho/org.eclipse.paho.mqtt.golang.git",
    :revision => "dbd8d5c40a582eb9adacde36b47932b3a3ad0034"
  end

  go_resource "github.com/Shopify/sarama" do
    url "https://github.com/Shopify/sarama.git",
    :revision => "c36adfa07b2d88dce4a02ca821367cb03a12068a"
  end

  go_resource "github.com/Sirupsen/logrus" do
    url "https://github.com/Sirupsen/logrus.git",
    :revision => "446d1c146faa8ed3f4218f056fcd165f6bcfda81"
  end

  go_resource "github.com/amir/raidman" do
    url "https://github.com/amir/raidman.git",
    :revision => "6a8e089bbe32e6b907feae5ba688841974b3c339"
  end

  go_resource "github.com/armon/go-metrics" do
    url "https://github.com/armon/go-metrics.git",
    :revision => "06b60999766278efd6d2b5d8418a58c3d5b99e87"
  end

  go_resource "github.com/beorn7/perks" do
    url "https://github.com/beorn7/perks.git",
    :revision => "b965b613227fddccbfffe13eae360ed3fa822f8d"
  end

  go_resource "github.com/boltdb/bolt" do
    url "https://github.com/boltdb/bolt.git",
    :revision => "b34b35ea8d06bb9ae69d9a349119252e4c1d8ee0"
  end

  go_resource "github.com/cenkalti/backoff" do
    url "https://github.com/cenkalti/backoff.git",
    :revision => "4dc77674aceaabba2c7e3da25d4c823edfb73f99"
  end

  go_resource "github.com/dancannon/gorethink" do
    url "https://github.com/dancannon/gorethink.git",
    :revision => "a124c9663325ed9f7fb669d17c69961b59151e6e"
  end

  go_resource "github.com/davecgh/go-spew" do
    url "https://github.com/davecgh/go-spew.git",
    :revision => "5215b55f46b2b919f50a1df0eaa5886afe4e3b3d"
  end

  go_resource "github.com/eapache/go-resiliency" do
    url "https://github.com/eapache/go-resiliency.git",
    :revision => "f341fb4dca45128e4aa86389fa6a675d55fe25e1"
  end

  go_resource "github.com/eapache/queue" do
    url "https://github.com/eapache/queue.git",
    :revision => "ded5959c0d4e360646dc9e9908cff48666781367"
  end

  go_resource "github.com/fsouza/go-dockerclient" do
    url "https://github.com/fsouza/go-dockerclient.git",
    :revision => "b515e07d61c4e873407b54c4843b0f3ac9aa16f1"
  end

  go_resource "github.com/go-sql-driver/mysql" do
    url "https://github.com/go-sql-driver/mysql.git",
    :revision => "d512f204a577a4ab037a1816604c48c9c13210be"
  end

  go_resource "github.com/gogo/protobuf" do
    url "https://github.com/gogo/protobuf.git",
    :revision => "e492fd34b12d0230755c45aa5fb1e1eea6a84aa9"
  end

  go_resource "github.com/golang/protobuf" do
    url "https://github.com/golang/protobuf.git",
    :revision => "68415e7123da32b07eab49c96d2c4d6158360e9b"
  end

  go_resource "github.com/golang/snappy" do
    url "https://github.com/golang/snappy.git",
    :revision => "723cc1e459b8eea2dea4583200fd60757d40097a"
  end

  go_resource "github.com/gonuts/go-shellquote" do
    url "https://github.com/gonuts/go-shellquote.git",
    :revision => "e842a11b24c6abfb3dd27af69a17f482e4b483c2"
  end

  go_resource "github.com/hailocab/go-hostpool" do
    url "https://github.com/hailocab/go-hostpool.git",
    :revision => "0637eae892be221164aff5fcbccc57171aea6406"
  end

  go_resource "github.com/hashicorp/go-msgpack" do
    url "https://github.com/hashicorp/go-msgpack.git",
    :revision => "fa3f63826f7c23912c15263591e65d54d080b458"
  end

  go_resource "github.com/hashicorp/raft" do
    url "https://github.com/hashicorp/raft.git",
    :revision => "d136cd15dfb7876fd7c89cad1995bc4f19ceb294"
  end

  go_resource "github.com/hashicorp/raft-boltdb" do
    url "https://github.com/hashicorp/raft-boltdb.git",
    :revision => "d1e82c1ec3f15ee991f7cc7ffd5b67ff6f5bbaee"
  end

  go_resource "github.com/influxdb/influxdb" do
    url "https://github.com/influxdb/influxdb.git",
    :revision => "38295d83d1fb8bdbfd89365f7309c4d8c0ac8ec9"
  end

  go_resource "github.com/klauspost/crc32" do
    url "https://github.com/klauspost/crc32.git",
    :revision => "0aff1ea9c20474c3901672b5b6ead0ac611156de"
  end

  go_resource "github.com/lib/pq" do
    url "https://github.com/lib/pq.git",
    :revision => "11fc39a580a008f1f39bb3d11d984fb34ed778d9"
  end

  go_resource "github.com/matttproud/golang_protobuf_extensions" do
    url "https://github.com/matttproud/golang_protobuf_extensions.git",
    :revision => "d0c3fe89de86839aecf2e0579c40ba3bb336a453"
  end

  go_resource "github.com/mreiferson/go-snappystream" do
    url "https://github.com/mreiferson/go-snappystream.git",
    :revision => "028eae7ab5c4c9e2d1cb4c4ca1e53259bbe7e504"
  end

  go_resource "github.com/naoina/go-stringutil" do
    url "https://github.com/naoina/go-stringutil.git",
    :revision => "6b638e95a32d0c1131db0e7fe83775cbea4a0d0b"
  end

  go_resource "github.com/naoina/toml" do
    url "https://github.com/naoina/toml.git",
    :revision => "751171607256bb66e64c9f0220c00662420c38e9"
  end

  go_resource "github.com/nsqio/go-nsq" do
    url "https://github.com/nsqio/go-nsq.git",
    :revision => "2118015c120962edc5d03325c680daf3163a8b5f"
  end

  go_resource "github.com/pborman/uuid" do
    url "https://github.com/pborman/uuid.git",
    :revision => "cccd189d45f7ac3368a0d127efb7f4d08ae0b655"
  end

  go_resource "github.com/pmezard/go-difflib" do
    url "https://github.com/pmezard/go-difflib.git",
    :revision => "e8554b8641db39598be7f6342874b958f12ae1d4"
  end

  go_resource "github.com/prometheus/client_golang" do
    url "https://github.com/prometheus/client_golang.git",
    :revision => "67994f177195311c3ea3d4407ed0175e34a4256f"
  end

  go_resource "github.com/prometheus/client_model" do
    url "https://github.com/prometheus/client_model.git",
    :revision => "fa8ad6fec33561be4280a8f0514318c79d7f6cb6"
  end

  go_resource "github.com/prometheus/common" do
    url "https://github.com/prometheus/common.git",
    :revision => "5cb53e5c863aca6e2b8ec958d16d9a93753ecea6"
  end

  go_resource "github.com/prometheus/procfs" do
    url "https://github.com/prometheus/procfs.git",
    :revision => "406e5b7bfd8201a36e2bb5f7bdae0b03380c2ce8"
  end

  go_resource "github.com/samuel/go-zookeeper" do
    url "https://github.com/samuel/go-zookeeper.git",
    :revision => "218e9c81c0dd8b3b18172b2bbfad92cc7d6db55f"
  end

  go_resource "github.com/shirou/gopsutil" do
    url "https://github.com/shirou/gopsutil.git",
    :revision => "fc932d9090f13a84fb4b3cb8baa124610cab184c"
  end

  go_resource "github.com/streadway/amqp" do
    url "https://github.com/streadway/amqp.git",
    :revision => "b4f3ceab0337f013208d31348b578d83c0064744"
  end

  go_resource "github.com/stretchr/objx" do
    url "https://github.com/stretchr/objx.git",
    :revision => "1a9d0bb9f541897e62256577b352fdbc1fb4fd94"
  end

  go_resource "github.com/stretchr/testify" do
    url "https://github.com/stretchr/testify.git",
    :revision => "e3a8ff8ce36581f87a15341206f205b1da467059"
  end

  go_resource "github.com/wvanbergen/kafka" do
    url "https://github.com/wvanbergen/kafka.git",
    :revision => "1a8639a45164fcc245d5c7b4bd3ccfbd1a0ffbf3"
  end

  go_resource "github.com/wvanbergen/kazoo-go" do
    url "https://github.com/wvanbergen/kazoo-go.git",
    :revision => "0f768712ae6f76454f987c3356177e138df258f8"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
    :revision => "7b85b097bf7527677d54d3220065e966a0e3b613"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
    :revision => "1796f9b8b7178e3c7587dff118d3bb9d37f9b0b3"
  end

  go_resource "gopkg.in/dancannon/gorethink.v1" do
    url "https://gopkg.in/dancannon/gorethink.v1.git",
    :revision => "a124c9663325ed9f7fb669d17c69961b59151e6e"
  end

  go_resource "gopkg.in/fatih/pool.v2" do
    url "https://gopkg.in/fatih/pool.v2.git",
    :revision => "cba550ebf9bce999a02e963296d4bc7a486cb715"
  end

  go_resource "gopkg.in/mgo.v2" do
    url "https://gopkg.in/mgo.v2.git",
    :revision => "e30de8ac9ae3b30df7065f766c71f88bba7d4e49"
  end

  go_resource "gopkg.in/yaml.v2" do
    url "https://gopkg.in/yaml.v2.git",
    :revision => "f7716cbe52baa25d2e9b0d0da546fcf909fc16b4"
  end

  def install
    ENV["GOPATH"] = buildpath

    telegraf_path = buildpath/"src/github.com/influxdb/telegraf"
    telegraf_path.install Dir["*"]

    Language::Go.stage_deps resources, buildpath/"src"

    cd telegraf_path do
      system "go", "build", "-o", "telegraf",
             "-ldflags", "-X main.Version=#{version}",
             "cmd/telegraf/telegraf.go"
    end

    bin.install telegraf_path/"telegraf"
    etc.install telegraf_path/"etc/telegraf.conf" => "telegraf.conf"
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
    (testpath/"config.toml").write shell_output("telegraf -sample-config")
    system "telegraf", "-config", testpath/"config.toml", "-test",
           "-filter", "cpu:mem"
  end
end
