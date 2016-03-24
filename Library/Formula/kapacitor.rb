require "language/go"

class Kapacitor < Formula
  desc "Open source time series data processor"
  homepage "https://github.com/influxdata/kapacitor"
  url "https://github.com/influxdata/kapacitor.git",
    :tag => "v0.11.0",
    :revision => "97ac4edb295c9f11b5c428fe5906bc6aa4e0865b"

  head "https://github.com/influxdata/kapacitor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a9dd1fec28dc4863bb8983721ad79213a3911eeed2934fd963ecf37bf772096c" => :el_capitan
    sha256 "52de9ce4609f2d138e5ff8b2bc69dbf6dbc3beb8c9f5ede2c8d12816e385f4ca" => :yosemite
    sha256 "115703595c641ed2007eec944ae4605b95a1ca4550440b19a5712585f88af7fd" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/BurntSushi/toml" do
    url "https://github.com/BurntSushi/toml.git",
    :revision => "bbd5bb678321a0d6e58f1099321dfa73391c1b6f"
  end

  go_resource "github.com/boltdb/bolt" do
    url "https://github.com/boltdb/bolt.git",
    :revision => "c2610ee091a94978d6092586b2b98b78cd8f7aca"
  end

  go_resource "github.com/cenkalti/backoff" do
    url "https://github.com/cenkalti/backoff.git",
    :revision => "32cd0c5b3aef12c76ed64aaf678f6c79736be7dc"
  end

  go_resource "github.com/dustin/go-humanize" do
    url "https://github.com/dustin/go-humanize.git",
    :revision => "8929fe90cee4b2cb9deb468b51fb34eba64d1bf0"
  end

  go_resource "github.com/gogo/protobuf" do
    url "https://github.com/gogo/protobuf.git",
    :revision => "4168943e65a2802828518e95310aeeed6d84c4e5"
  end

  go_resource "github.com/gorhill/cronexpr" do
    url "https://github.com/gorhill/cronexpr.git",
    :revision => "f0984319b44273e83de132089ae42b1810f4933b"
  end

  go_resource "github.com/influxdata/influxdb" do
    url "https://github.com/influxdata/influxdb.git",
    :revision => "5e8e849ebdeb66e13a4c32069acd101e23f368f9"
  end

  go_resource "github.com/influxdb/usage-client" do
    url "https://github.com/influxdb/usage-client.git",
    :revision => "475977e68d79883d9c8d67131c84e4241523f452"
  end

  go_resource "github.com/kimor79/gollectd" do
    url "https://github.com/kimor79/gollectd.git",
    :revision => "b5dddb1667dcc1e6355b9305e2c1608a2db6983c"
  end

  go_resource "github.com/mattn/go-runewidth" do
    url "https://github.com/mattn/go-runewidth.git",
    :revision => "d6bea18f789704b5f83375793155289da36a3c7f"
  end

  go_resource "github.com/russross/blackfriday" do
    url "https://github.com/russross/blackfriday.git",
    :revision => "b43df972fb5fdf3af8d2e90f38a69d374fe26dd0"
  end

  go_resource "github.com/serenize/snaker" do
    url "https://github.com/serenize/snaker.git",
    :revision => "8824b61eca66d308fcb2d515287d3d7a28dba8d6"
  end

  go_resource "github.com/shurcooL/go" do
    url "https://github.com/shurcooL/go.git",
    :revision => "4df21823efe0d75ceac67879b43bcd28c8b864ad"
  end

  go_resource "github.com/shurcooL/markdownfmt" do
    url "https://github.com/shurcooL/markdownfmt.git",
    :revision => "f9ece38f23b0150fcfaa82de98ec43ce0b98a83e"
  end

  go_resource "github.com/shurcooL/sanitized_anchor_name" do
    url "https://github.com/shurcooL/sanitized_anchor_name.git",
    :revision => "10ef21a441db47d8b13ebcc5fd2310f636973c77"
  end

  go_resource "github.com/stretchr/testify" do
    url "https://github.com/stretchr/testify.git",
    :revision => "f390dcf405f7b83c997eac1b06768bb9f44dec18"
  end

  go_resource "github.com/twinj/uuid" do
    url "https://github.com/twinj/uuid.git",
    :revision => "89173bcdda19db0eb88aef1e1cb1cb2505561d31"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
    :revision => "c197bcf24cde29d3f73c7b4ac6fd41f4384e8af6"
  end

  go_resource "gopkg.in/gomail.v2" do
    url "https://gopkg.in/gomail.v2.git",
    :revision => "84856b343c307d0d076818e93d6122b71591c4a7"
  end

  def install
    ENV["GOPATH"] = buildpath
    kapacitor_path = buildpath/"src/github.com/influxdata/kapacitor"
    kapacitor_path.install Dir["*"]
    revision = `git rev-parse HEAD`

    Language::Go.stage_deps resources, buildpath/"src"

    cd kapacitor_path do
      system "go", "install",
             "-ldflags", "-X main.version=#{version} -X main.commit=#{revision}",
             "./..."
    end

    inreplace kapacitor_path/"etc/kapacitor/kapacitor.conf" do |s|
      s.gsub! "/var/lib/kapacitor", "#{var}/kapacitor"
      s.gsub! "/var/log/kapacitor", "#{var}/log"
    end

    bin.install "bin/kapacitord"
    bin.install "bin/kapacitor"
    etc.install kapacitor_path/"etc/kapacitor/kapacitor.conf" => "kapacitor.conf"

    (var/"kapacitor/replay").mkpath
    (var/"kapacitor/tasks").mkpath
  end

  plist_options :manual => "kapacitord -config #{HOMEBREW_PREFIX}/etc/kapacitor.conf"

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
          <string>#{opt_bin}/kapacitord</string>
          <string>-config</string>
          <string>#{HOMEBREW_PREFIX}/etc/kapacitor.conf</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/kapacitor.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/kapacitor.log</string>
      </dict>
    </plist>
    EOS
  end

  test do
    (testpath/"config.toml").write shell_output("kapacitord config")

    inreplace testpath/"config.toml" do |s|
      s.gsub! /\[\[influxdb\]\]\n  enabled = true/m, "[[influxdb]]\n  enabled = false"
      s.gsub! %r{data_dir = "/.*/.kapacitor}, "data_dir = \"#{testpath}/kapacitor"
      s.gsub! %r{/.*/.kapacitor/replay}, "#{testpath}/kapacitor/replay"
      s.gsub! %r{/.*/.kapacitor/tasks}, "#{testpath}/kapacitor/tasks"
    end

    pid = fork do
      exec "#{bin}/kapacitord -config #{testpath}/config.toml"
    end
    sleep 2

    begin
      shell_output("#{bin}/kapacitor level info")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
