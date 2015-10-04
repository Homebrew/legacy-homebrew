require "language/go"

class Telegraf < Formula
  desc "Server-level metric gathering agent for InfluxDB"
  homepage "https://influxdb.com"
  url "https://github.com/influxdb/telegraf/archive/v0.1.9.tar.gz"
  sha256 "04765e691ff287c4c5eed67409a8bb26718a6413c3d730c7f019215ba28704af"

  bottle do
    cellar :any_skip_relocation
    sha256 "6769b07add42cd6635f5a3e99dfc5bb750db5aacd69234a69a9f4f827eed4789" => :el_capitan
    sha256 "be0c12d61f4fce374a0780ac7aae033c9a8ca8ef0ab97dd2737d712d91b91c65" => :yosemite
    sha256 "44e0ab0a34ce70c2cf6443c487d8fea4c999860177459a1b2f5765074d575d5d" => :mavericks
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
