require "language/go"

class Telegraf < Formula
  desc "Server-level metric gathering agent for InfluxDB"
  homepage "https://influxdata.com"
  url "https://github.com/influxdata/telegraf/archive/0.10.3.tar.gz"
  sha256 "00673003a0e190f30a69a23f51a84ce0bc9d2efb1a1142b0dfdb697524229e59"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "050df2070631c21e1333afc9eb41ee7072a22094bda98794adaeb97de303e627" => :el_capitan
    sha256 "bc27074ee461a668ac1c6a384d30dc41a29572347bd5367938c8a3c057316c2f" => :yosemite
    sha256 "07e67e5fe15bd190e2206e9ad0a4a0868a01ba4e3b49081a48605eb39709b4bf" => :mavericks
  end

  depends_on "go" => :build

  go_resource "git.eclipse.org/gitroot/paho/org.eclipse.paho.mqtt.golang.git" do
    url "https://git.eclipse.org/gitroot/paho/org.eclipse.paho.mqtt.golang.git",
    :revision => "617c801af238c3af2d9e72c5d4a0f02edad03ce5"
  end

  go_resource "github.com/Shopify/sarama" do
    url "https://github.com/Shopify/sarama.git",
    :revision => "d37c73f2b2bce85f7fa16b6a550d26c5372892ef"
  end

  go_resource "github.com/Sirupsen/logrus" do
    url "https://github.com/Sirupsen/logrus.git",
    :revision => "f7f79f729e0fbe2fcc061db48a9ba0263f588252"
  end

  go_resource "github.com/amir/raidman" do
    url "https://github.com/amir/raidman.git",
    :revision => "6a8e089bbe32e6b907feae5ba688841974b3c339"
  end

  go_resource "github.com/aws/aws-sdk-go" do
    url "https://github.com/aws/aws-sdk-go.git",
    :revision => "87b1e60a50b09e4812dee560b33a238f67305804"
  end

  go_resource "github.com/beorn7/perks" do
    url "https://github.com/beorn7/perks.git",
    :revision => "b965b613227fddccbfffe13eae360ed3fa822f8d"
  end

  go_resource "github.com/cenkalti/backoff" do
    url "https://github.com/cenkalti/backoff.git",
    :revision => "4dc77674aceaabba2c7e3da25d4c823edfb73f99"
  end

  go_resource "github.com/dancannon/gorethink" do
    url "https://github.com/dancannon/gorethink.git",
    :revision => "6f088135ff288deb9d5546f4c71919207f891a70"
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
    :revision => "7b651349f9479f5114913eefbfd3c4eeddd79ab4"
  end

  go_resource "github.com/go-sql-driver/mysql" do
    url "https://github.com/go-sql-driver/mysql.git",
    :revision => "7c7f556282622f94213bc028b4d0a7b6151ba239"
  end

  go_resource "github.com/golang/protobuf" do
    url "https://github.com/golang/protobuf.git",
    :revision => "6aaa8d47701fa6cf07e914ec01fde3d4a1fe79c3"
  end

  go_resource "github.com/golang/snappy" do
    url "https://github.com/golang/snappy.git",
    :revision => "723cc1e459b8eea2dea4583200fd60757d40097a"
  end

  go_resource "github.com/gonuts/go-shellquote" do
    url "https://github.com/gonuts/go-shellquote.git",
    :revision => "e842a11b24c6abfb3dd27af69a17f482e4b483c2"
  end

  go_resource "github.com/gorilla/context" do
    url "https://github.com/gorilla/context.git",
    :revision => "1c83b3eabd45b6d76072b66b746c20815fb2872d"
  end

  go_resource "github.com/gorilla/mux" do
    url "https://github.com/gorilla/mux.git",
    :revision => "26a6070f849969ba72b72256e9f14cf519751690"
  end

  go_resource "github.com/hailocab/go-hostpool" do
    url "https://github.com/hailocab/go-hostpool.git",
    :revision => "e80d13ce29ede4452c43dea11e79b9bc8a15b478"
  end

  go_resource "github.com/influxdata/config" do
    url "https://github.com/influxdata/config.git",
    :revision => "bae7cb98197d842374d3b8403905924094930f24"
  end

  go_resource "github.com/influxdata/influxdb" do
    url "https://github.com/influxdata/influxdb.git",
    :revision => "ef571fc104dc24b77cd3710c156cd95e5cfd7aa5"
  end

  go_resource "github.com/klauspost/crc32" do
    url "https://github.com/klauspost/crc32.git",
    :revision => "999f3125931f6557b991b2f8472172bdfa578d38"
  end

  go_resource "github.com/lib/pq" do
    url "https://github.com/lib/pq.git",
    :revision => "8ad2b298cadd691a77015666a5372eae5dbfac8f"
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

  go_resource "github.com/nats-io/nats" do
    url "https://github.com/nats-io/nats.git",
    :revision => "6a83f1a633cfbfd90aa648ac99fb38c06a8b40df"
  end

  go_resource "github.com/nsqio/go-nsq" do
    url "https://github.com/nsqio/go-nsq.git",
    :revision => "2118015c120962edc5d03325c680daf3163a8b5f"
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
    :revision => "14ca1097bbe21584194c15e391a9dab95ad42a59"
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
    :revision => "e77438504d45b9985c99a75730fe65220ceea00e"
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
    :revision => "f390dcf405f7b83c997eac1b06768bb9f44dec18"
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
    :revision => "1f22c0103821b9390939b6776727195525381532"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
    :revision => "04b9de9b512f58addf28c9853d50ebef61c3953e"
  end

  go_resource "golang.org/x/text" do
    url "https://go.googlesource.com/text.git",
    :revision => "6d3c22c4525a4da167968fa2479be5524d2e8bd0"
  end

  go_resource "gopkg.in/dancannon/gorethink.v1" do
    url "https://gopkg.in/dancannon/gorethink.v1.git",
    :revision => "6f088135ff288deb9d5546f4c71919207f891a70"
  end

  go_resource "gopkg.in/fatih/pool.v2" do
    url "https://gopkg.in/fatih/pool.v2.git",
    :revision => "cba550ebf9bce999a02e963296d4bc7a486cb715"
  end

  go_resource "gopkg.in/mgo.v2" do
    url "https://gopkg.in/mgo.v2.git",
    :revision => "03c9f3ee4c14c8e51ee521a6a7d0425658dd6f64"
  end

  go_resource "gopkg.in/yaml.v2" do
    url "https://gopkg.in/yaml.v2.git",
    :revision => "f7716cbe52baa25d2e9b0d0da546fcf909fc16b4"
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
