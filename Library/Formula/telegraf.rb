require "language/go"

class Telegraf < Formula
  desc "Server-level metric gathering agent for InfluxDB"
  homepage "https://influxdb.com"
  url "https://github.com/influxdb/telegraf/archive/v0.1.4.tar.gz"
  sha256 "df586d0ada7e808b62ff476efd87c5a35e69a98bc45b3bf9823751cbccecc017"

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
    assert_match /Telegraf/, shell_output("telegraf -version")
  end
end
