require "language/go"

class Kapacitor < Formula
  desc "Open source time series data processor"
  homepage "https://github.com/influxdb/kapacitor"
  url "https://github.com/influxdb/kapacitor.git",
    :tag => "v0.2.0",
    :revision => "18b2061efb263aae326f51bd74d7023a221996ef"

  head "https://github.com/influxdb/kapacitor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4c75d2db70eb2c5952209f79cab6dccb4c3766a107082405da7db0151c45031e" => :el_capitan
    sha256 "5c5097b0507ebd543a2519167bb8fd876b87fdb3e3289c22a1583e4c7a2aa5a5" => :yosemite
    sha256 "40cea054a5b5579108fee3d6217cafd789cc39d910f3d930905d96668f32eb9c" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/armon/go-metrics" do
    url "https://github.com/armon/go-metrics.git",
      :revision => "6c5fa0d8f48f4661c9ba8709799c88d425ad20f0"
  end

  go_resource "github.com/boltdb/bolt" do
    url "https://github.com/boltdb/bolt.git",
      :revision => "6e1ca38c6a73025366cd8705553b404746ee6e63"
  end

  go_resource "github.com/gogo/protobuf" do
    url "https://github.com/gogo/protobuf.git",
      :revision => "d3235f01ecae4901dd9f7ea6af57a352c0189deb"
  end

  go_resource "github.com/gorhill/cronexpr" do
    url "https://github.com/gorhill/cronexpr.git",
      :revision => "a557574d6c024ed6e36acc8b610f5f211c91568a"
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

  go_resource "github.com/influxdb/enterprise-client" do
    url "https://github.com/influxdb/enterprise-client.git",
      :revision => "25665cba4f54fa822546c611c9414ac31aa10faa"
  end

  go_resource "github.com/influxdb/influxdb" do
    url "https://github.com/influxdb/influxdb.git",
      :revision => "45502d288f79b60051a7ec9260ad59dacb5b1a6c"
  end

  go_resource "github.com/twinj/uuid" do
    url "https://github.com/twinj/uuid.git",
      :revision => "89173bcdda19db0eb88aef1e1cb1cb2505561d31"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
      :revision => "beef0f4390813b96e8e68fd78570396d0f4751fc"
  end

  go_resource "gopkg.in/fatih/pool.v2" do
    url "https://gopkg.in/fatih/pool.v2.git",
      :revision => "cba550ebf9bce999a02e963296d4bc7a486cb715"
  end

  go_resource "github.com/BurntSushi/toml" do
    url "https://github.com/BurntSushi/toml.git",
      :revision => "056c9bc7be7190eaa7715723883caffa5f8fa3e4"
  end

  go_resource "github.com/kimor79/gollectd" do
    url "https://github.com/kimor79/gollectd.git",
      :revision => "61d0deeb4ffcc167b2a1baa8efd72365692811bc"
  end

  go_resource "gopkg.in/gomail.v2" do
    url "https://gopkg.in/gomail.v2.git",
      :revision => "41f3572897373c5538c50a2402db15db079fa4fd"
  end

  go_resource "github.com/serenize/snaker" do
    url "https://github.com/serenize/snaker.git",
      :revision => "d88cc11617e4f179fa2c821a60908d5fabd7bdad"
  end

  go_resource "github.com/shurcooL/markdownfmt" do
    url "https://github.com/shurcooL/markdownfmt.git",
      :revision => "c6ad3c69d14e5089336af1e41e595f0826df1b82"
  end

  go_resource "github.com/dustin/go-humanize" do
    url "https://github.com/dustin/go-humanize.git",
      :revision => "64dbdae0d393b7d71480a6dace78456396b55286"
  end

  go_resource "github.com/mattn/go-runewidth" do
    url "https://github.com/mattn/go-runewidth.git",
      :revision => "d96d1bd051f2bd9e7e43d602782b37b93b1b5666"
  end

  go_resource "github.com/russross/blackfriday" do
    url "https://github.com/russross/blackfriday.git",
      :revision => "300106c228d52c8941d4b3de6054a6062a86dda3"
  end

  go_resource "github.com/shurcooL/go" do
    url "https://github.com/shurcooL/go.git",
      :revision => "ee4d3ba2f39466dd17fc55dd260e89b8963640f8"
  end

  go_resource "github.com/shurcooL/sanitized_anchor_name" do
    url "https://github.com/shurcooL/sanitized_anchor_name.git",
      :revision => "10ef21a441db47d8b13ebcc5fd2310f636973c77"
  end

  def install
    ENV["GOPATH"] = buildpath
    kapacitor_path = buildpath/"src/github.com/influxdb/kapacitor"
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
    logo = <<-EOS.undent
      '##:::'##::::'###::::'########:::::'###:::::'######::'####:'########::'#######::'########::
       ##::'##::::'## ##::: ##.... ##:::'## ##:::'##... ##:. ##::... ##..::'##.... ##: ##.... ##:
       ##:'##::::'##:. ##:: ##:::: ##::'##:. ##:: ##:::..::: ##::::: ##:::: ##:::: ##: ##:::: ##:
       #####::::'##:::. ##: ########::'##:::. ##: ##:::::::: ##::::: ##:::: ##:::: ##: ########::
       ##. ##::: #########: ##.....::: #########: ##:::::::: ##::::: ##:::: ##:::: ##: ##.. ##:::
       ##:. ##:: ##.... ##: ##:::::::: ##.... ##: ##::: ##:: ##::::: ##:::: ##:::: ##: ##::. ##::
       ##::. ##: ##:::: ##: ##:::::::: ##:::: ##:. ######::'####:::: ##::::. #######:: ##:::. ##:
      ..::::..::..:::::..::..:::::::::..:::::..:::......:::....:::::..::::::.......:::..:::::..::
    EOS
    (testpath/"config.toml").write shell_output("kapacitord config")
    assert_match /#{logo}/m, shell_output("kapacitord -config #{testpath}/config.toml", 1)
  end
end
