require "language/go"

class Telegraf < Formula
  desc "Server-level agent for InfluxDB"
  homepage "https://influxdb.com"
  # github auto-creates these archives for each tag:
  url "https://github.com/influxdb/telegraf/archive/v0.1.4.tar.gz"
  # must re-calculate the sha256 of the archive when updating this:
  sha256 "360214616498496567d7e8bf5120c8ed4afad06e62ed737c38506265413c5c05"

  bottle do
    cellar :any
    sha256 "6cb91d8c1db1d84ff45dcda761ac5cb5d6da11d652618a1952555dda5869d846" => :yosemite
    sha256 "e145923cd453a2d7ed19a2a5912858b5926d78cc95161dfc6caacd487911d819" => :mavericks
    sha256 "2ced74471933b8877527934828d6c1881c1f306ea8f5d0d5013774b5b721eed1" => :mountain_lion
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    telegraf_path = buildpath/"src/github.com/influxdb/telegraf"
    telegraf_path.install Dir["*"]

    cd telegraf_path do
      system "go", "get", "-u", "-f", "-d", "./..."
      # Must update main.Version when updating package:
      system "go", "build", "-o", "telegraf", "-ldflags", "-X main.Version 0.1.4", "cmd/telegraf/telegraf.go"
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
