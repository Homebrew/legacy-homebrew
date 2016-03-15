require "language/go"

class Telegraf < Formula
  desc "Server-level metric gathering agent for InfluxDB"
  homepage "https://influxdata.com"
  url "https://github.com/influxdata/telegraf/archive/0.11.0.tar.gz"
  sha256 "ad9e1be76b1f66f76246e200fb6f249ff43dc2413eb35d2551b7817799bae042"

  bottle do
    cellar :any_skip_relocation
    sha256 "edee960086e7edc4fc6c1c9faf0e9b0d5542b197e988aa26e08eb4ebd51a31ad" => :el_capitan
    sha256 "9510b0420da15be9c0804b3ddd6604b47fb294da87809a9f533a9fe8b18343c3" => :yosemite
    sha256 "90d90836da7de441feeaee2b4d4443e399084c0c2e67b209f5f14970b25e1752" => :mavericks
  end

  depends_on "go" => :build

  go_resource "git.eclipse.org/gitroot/paho/org.eclipse.paho.mqtt.golang.git" do
    url "git://git.eclipse.org/gitroot/paho/org.eclipse.paho.mqtt.golang.git",
    :revision => "617c801af238c3af2d9e72c5d4a0f02edad03ce5"
  end

  go_resource "github.com/Shopify/sarama" do
    url "https://github.com/Shopify/sarama.git",
    :revision => "8aadb476e66ca998f2f6bb3c993e9a2daa3666b9"
  end

  go_resource "github.com/Sirupsen/logrus" do
    url "https://github.com/Sirupsen/logrus.git",
    :revision => "219c8cb75c258c552e999735be6df753ffc7afdc"
  end

  go_resource "github.com/amir/raidman" do
    url "https://github.com/amir/raidman.git",
    :revision => "53c1b967405155bfc8758557863bf2e14f814687"
  end

  go_resource "github.com/aws/aws-sdk-go" do
    url "https://github.com/aws/aws-sdk-go.git",
    :revision => "13a12060f716145019378a10e2806c174356b857"
  end

  go_resource "github.com/beorn7/perks" do
    url "https://github.com/beorn7/perks.git",
    :revision => "3ac7bf7a47d159a033b107610db8a1b6575507a4"
  end

  go_resource "github.com/cenkalti/backoff" do
    url "https://github.com/cenkalti/backoff.git",
    :revision => "4dc77674aceaabba2c7e3da25d4c823edfb73f99"
  end

  go_resource "github.com/dancannon/gorethink" do
    url "https://github.com/dancannon/gorethink.git",
    :revision => "e7cac92ea2bc52638791a021f212145acfedb1fc"
  end

  go_resource "github.com/davecgh/go-spew" do
    url "https://github.com/davecgh/go-spew.git",
    :revision => "5215b55f46b2b919f50a1df0eaa5886afe4e3b3d"
  end

  go_resource "github.com/eapache/go-resiliency" do
    url "https://github.com/eapache/go-resiliency.git",
    :revision => "b86b1ec0dd4209a588dc1285cdd471e73525c0b3"
  end

  go_resource "github.com/eapache/queue" do
    url "https://github.com/eapache/queue.git",
    :revision => "ded5959c0d4e360646dc9e9908cff48666781367"
  end

  go_resource "github.com/fsouza/go-dockerclient" do
    url "https://github.com/fsouza/go-dockerclient.git",
    :revision => "a49c8269a6899cae30da1f8a4b82e0ce945f9967"
  end

  go_resource "github.com/go-sql-driver/mysql" do
    url "https://github.com/go-sql-driver/mysql.git",
    :revision => "1fca743146605a172a266e1654e01e5cd5669bee"
  end

  go_resource "github.com/golang/protobuf" do
    url "https://github.com/golang/protobuf.git",
    :revision => "552c7b9542c194800fd493123b3798ef0a832032"
  end

  go_resource "github.com/golang/snappy" do
    url "https://github.com/golang/snappy.git",
    :revision => "427fb6fc07997f43afa32f35e850833760e489a7"
  end

  go_resource "github.com/gonuts/go-shellquote" do
    url "https://github.com/gonuts/go-shellquote.git",
    :revision => "e842a11b24c6abfb3dd27af69a17f482e4b483c2"
  end

  go_resource "github.com/gorilla/context" do
    url "https://github.com/gorilla/context.git",
    :revision => "1ea25387ff6f684839d82767c1733ff4d4d15d0a"
  end

  go_resource "github.com/gorilla/mux" do
    url "https://github.com/gorilla/mux.git",
    :revision => "c9e326e2bdec29039a3761c07bece13133863e1e"
  end

  go_resource "github.com/hailocab/go-hostpool" do
    url "https://github.com/hailocab/go-hostpool.git",
    :revision => "e80d13ce29ede4452c43dea11e79b9bc8a15b478"
  end

  go_resource "github.com/influxdata/config" do
    url "https://github.com/influxdata/config.git",
    :revision => "b79f6829346b8d6e78ba73544b1e1038f1f1c9da"
  end

  go_resource "github.com/influxdata/influxdb" do
    url "https://github.com/influxdata/influxdb.git",
    :revision => "e3fef5593c21644f2b43af55d6e17e70910b0e48"
  end

  go_resource "github.com/influxdata/toml" do
    url "https://github.com/influxdata/toml.git",
    :revision => "af4df43894b16e3fd2b788d01bd27ad0776ef2d0"
  end

  go_resource "github.com/klauspost/crc32" do
    url "https://github.com/klauspost/crc32.git",
    :revision => "19b0b332c9e4516a6370a0456e6182c3b5036720"
  end

  go_resource "github.com/lib/pq" do
    url "https://github.com/lib/pq.git",
    :revision => "e182dc4027e2ded4b19396d638610f2653295f36"
  end

  go_resource "github.com/matttproud/golang_protobuf_extensions" do
    url "https://github.com/matttproud/golang_protobuf_extensions.git",
    :revision => "d0c3fe89de86839aecf2e0579c40ba3bb336a453"
  end

  go_resource "github.com/miekg/dns" do
    url "https://github.com/miekg/dns.git",
    :revision => "cce6c130cdb92c752850880fd285bea1d64439dd"
  end

  go_resource "github.com/mreiferson/go-snappystream" do
    url "https://github.com/mreiferson/go-snappystream.git",
    :revision => "028eae7ab5c4c9e2d1cb4c4ca1e53259bbe7e504"
  end

  go_resource "github.com/naoina/go-stringutil" do
    url "https://github.com/naoina/go-stringutil.git",
    :revision => "6b638e95a32d0c1131db0e7fe83775cbea4a0d0b"
  end

  go_resource "github.com/nats-io/nats" do
    url "https://github.com/nats-io/nats.git",
    :revision => "b13fc9d12b0b123ebc374e6b808c6228ae4234a3"
  end

  go_resource "github.com/nats-io/nuid" do
    url "https://github.com/nats-io/nuid.git",
    :revision => "4f84f5f3b2786224e336af2e13dba0a0a80b76fa"
  end

  go_resource "github.com/nsqio/go-nsq" do
    url "https://github.com/nsqio/go-nsq.git",
    :revision => "0b80d6f05e15ca1930e0c5e1d540ed627e299980"
  end

  go_resource "github.com/prometheus/client_golang" do
    url "https://github.com/prometheus/client_golang.git",
    :revision => "18acf9993a863f4c4b40612e19cdd243e7c86831"
  end

  go_resource "github.com/prometheus/client_model" do
    url "https://github.com/prometheus/client_model.git",
    :revision => "fa8ad6fec33561be4280a8f0514318c79d7f6cb6"
  end

  go_resource "github.com/prometheus/common" do
    url "https://github.com/prometheus/common.git",
    :revision => "e8eabff8812b05acf522b45fdcd725a785188e37"
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
    :revision => "1de1357e7737a536c7f4ff6be7bd27977db4d2cb"
  end

  go_resource "github.com/soniah/gosnmp" do
    url "https://github.com/soniah/gosnmp.git",
    :revision => "b1b4f885b12c5dcbd021c5cee1c904110de6db7d"
  end

  go_resource "github.com/streadway/amqp" do
    url "https://github.com/streadway/amqp.git",
    :revision => "b4f3ceab0337f013208d31348b578d83c0064744"
  end

  go_resource "github.com/stretchr/testify" do
    url "https://github.com/stretchr/testify.git",
    :revision => "1f4a1643a57e798696635ea4c126e9127adb7d3c"
  end

  go_resource "github.com/wvanbergen/kafka" do
    url "https://github.com/wvanbergen/kafka.git",
    :revision => "1a8639a45164fcc245d5c7b4bd3ccfbd1a0ffbf3"
  end

  go_resource "github.com/wvanbergen/kazoo-go" do
    url "https://github.com/wvanbergen/kazoo-go.git",
    :revision => "0f768712ae6f76454f987c3356177e138df258f8"
  end

  go_resource "github.com/zensqlmonitor/go-mssqldb" do
    url "https://github.com/zensqlmonitor/go-mssqldb.git",
    :revision => "ffe5510c6fa5e15e6d983210ab501c815b56b363"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
    :revision => "5dc8cb4b8a8eb076cbb5a06bc3b8682c15bdbbd3"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
    :revision => "6acef71eb69611914f7a30939ea9f6e194c78172"
  end

  go_resource "golang.org/x/text" do
    url "https://go.googlesource.com/text.git",
    :revision => "a71fd10341b064c10f4a81ceac72bcf70f26ea34"
  end

  go_resource "gopkg.in/dancannon/gorethink.v1" do
    url "https://gopkg.in/dancannon/gorethink.v1.git",
    :revision => "7d1af5be49cb5ecc7b177bf387d232050299d6ef"
  end

  go_resource "gopkg.in/fatih/pool.v2" do
    url "https://gopkg.in/fatih/pool.v2.git",
    :revision => "cba550ebf9bce999a02e963296d4bc7a486cb715"
  end

  go_resource "gopkg.in/mgo.v2" do
    url "https://gopkg.in/mgo.v2.git",
    :revision => "d90005c5262a3463800497ea5a89aed5fe22c886"
  end

  go_resource "gopkg.in/yaml.v2" do
    url "https://gopkg.in/yaml.v2.git",
    :revision => "a83829b6f1293c91addabc89d0571c246397bbf4"
  end

  def install
    ENV["GOPATH"] = buildpath

    telegraf_path = buildpath/"src/github.com/influxdata/telegraf"
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
    (testpath/"config.toml").write shell_output("#{bin}/telegraf -sample-config")
    system "telegraf", "-config", testpath/"config.toml", "-test",
           "-input-filter", "cpu:mem"
  end
end
