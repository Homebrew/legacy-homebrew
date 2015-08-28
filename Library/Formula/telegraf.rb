require "language/go"

class Telegraf < Formula
  desc "Server-level metric gathering agent for InfluxDB"
  homepage "https://influxdb.com"
  url "https://github.com/influxdb/telegraf/archive/v0.1.7.tar.gz"
  sha256 "96a394f6208cd3d17ef2dbc32e9c7aa598a8ad017d27aa23a9362877d37ef730"

  bottle do
    cellar :any
    sha256 "72c80ceb238ee1e22acc1ec4c85ff10593ec672565f172fb318a8bd87a0b3c6e" => :yosemite
    sha256 "d40703839fda0ee59de56cbcfa41fd23a0f3c22b4c2b4fed37099e39334ca350" => :mavericks
    sha256 "9922d38d61d7f419a4d252a07b59a5929396b5139a121310b570252387584c51" => :mountain_lion
  end

  depends_on "go" => :build

  go_resource "github.com/tools/godep" do
    url "https://github.com/tools/godep.git",
      :revision => "fe7138c011ae7875d4af21efe8b237f4987d8c4a"
  end

  def install
    ENV["GOPATH"] = buildpath

    telegraf_path = buildpath/"src/github.com/influxdb/telegraf"
    telegraf_path.install Dir["*"]

    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/tools/godep" do
      system "go", "install"
    end

    cd telegraf_path do
      system "#{buildpath}/bin/godep", "go", "build", "-o", "telegraf",
             "-ldflags", "-X main.Version #{version}",
             "cmd/telegraf/telegraf.go"
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
    (testpath/"config.toml").write shell_output("telegraf -sample-config")
    system "telegraf", "-config", testpath/"config.toml", "-test",
           "-filter", "cpu:mem"
  end
end
