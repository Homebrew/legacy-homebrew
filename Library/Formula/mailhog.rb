require "language/go"

class Mailhog < Formula
  desc "Web and API based SMTP testing tool"
  homepage "https://github.com/mailhog/MailHog"
  url "https://github.com/mailhog/MailHog/archive/0.1.9.tar.gz"
  sha256 "2128208e5dbf25a812c31d745f3f40d32020304081fa4e811403b75b61bc828e"

  head "https://github.com/mailhog/MailHog.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3dd48eed82e2d07198630ee5be971ca3ef4bc975154b2859b97ae3e2d680e434" => :el_capitan
    sha256 "365e678cdd2cc4530a8169a54c4080759e8daa10f2520eaca438567ca0718dfd" => :yosemite
    sha256 "10a1d619424575d647b066f789390509f03dd750ad0892849a7801caa924832f" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/gorilla/context" do
    url "https://github.com/gorilla/context.git",
      :revision => "1c83b3eabd45b6d76072b66b746c20815fb2872d"
  end

  go_resource "github.com/gorilla/mux" do
    url "https://github.com/gorilla/mux.git",
      :revision => "ad4d7a5882b961e07e2626045eb995c022ac6664"
  end

  go_resource "github.com/gorilla/pat" do
    url "https://github.com/gorilla/pat.git",
      :revision => "e3ceaad21981965be815a74ec833802d74e52947"
  end

  go_resource "github.com/ian-kent/envconf" do
    url "https://github.com/ian-kent/envconf.git",
      :revision => "c19809918c02ab33dc8635d68c77649313185275"
  end

  go_resource "github.com/ian-kent/go-log" do
    url "https://github.com/ian-kent/go-log.git",
      :revision => "0d363706e0041a0431fbfa482d655738f7820db8"
  end

  go_resource "github.com/ian-kent/goose" do
    url "https://github.com/ian-kent/goose.git",
      :revision => "c3541ea826ad9e0f8a4a8c15ca831e8b0adde58c"
  end

  go_resource "github.com/ian-kent/linkio" do
    url "https://github.com/ian-kent/linkio.git",
      :revision => "77fb4b01842cb4b019137c0227df9a8f9779d0bd"
  end

  go_resource "github.com/jteeuwen/go-bindata" do
    url "https://github.com/jteeuwen/go-bindata.git",
      :revision => "1c1928d3b62dc79f5b35c32ae372a5fe69e9b4f1"
  end

  go_resource "github.com/mailhog/data" do
    url "https://github.com/mailhog/data.git",
      :revision => "36077cc82f0e00c479943a06173a600dedefd7a0"
  end

  go_resource "github.com/mailhog/http" do
    url "https://github.com/mailhog/http.git",
      :revision => "066a2dfd9d8bf7a94a2df4e1b4b9db3556b56bbb"
  end

  go_resource "github.com/mailhog/mhsendmail" do
    url "https://github.com/mailhog/mhsendmail.git",
      :revision => "0bba7051c64d8af0b436d0c47774d12a8684a3e1"
  end

  go_resource "github.com/mailhog/smtp" do
    url "https://github.com/mailhog/smtp.git",
      :revision => "8c087763ca1b9208b0890dab7aacd487c07ba06a"
  end

  go_resource "github.com/mailhog/storage" do
    url "https://github.com/mailhog/storage.git",
      :revision => "33a9b882525652a3e4b74b03716e0225de010ba4"
  end

  go_resource "github.com/mailhog/MailHog-Server" do
    url "https://github.com/mailhog/MailHog-Server.git",
      :revision => "1dfb973b724a309c18474fe032b1458c0d8654fc"
  end

  go_resource "github.com/mailhog/MailHog-UI" do
    url "https://github.com/mailhog/MailHog-UI.git",
      :revision => "ebdfa0f91fac40169ca376953d7c13f9d83cd01a"
  end

  go_resource "github.com/mailhog/MailHog" do
    url "https://github.com/mailhog/MailHog.git",
      :revision => "91a9d8afe119dc96a6c9acfa94c997765c824908"
  end

  go_resource "github.com/ogier/pflag" do
    url "https://github.com/ogier/pflag.git",
      :revision => "6f7159c3154e7cd4ab30f6cc9c58fa3fd0f22325"
  end

  go_resource "github.com/t-k/fluent-logger-golang" do
    url "https://github.com/t-k/fluent-logger-golang.git",
      :revision => "0f8ec08f2057a61574b6943e75045fffbeae894e"
  end

  go_resource "github.com/tinylib/msgp" do
    url "https://github.com/tinylib/msgp.git",
      :revision => "c46fbee0675f25770e5f340dc9bc22bf4a108ad4"
  end

  go_resource "golang.org/x/crypto" do
    url "https://github.com/golang/crypto.git",
      :revision => "c8b9e6388ef638d5a8a9d865c634befdc46a6784"
  end

  go_resource "github.com/philhofer/fwd" do
    url "https://github.com/philhofer/fwd.git",
      :revision => "8fd9a4b75098b2125fe442e48a3ffbf738254e13"
  end

  go_resource "labix.org/v2/mgo" do
    url "https://github.com/go-mgo/mgo.git",
      :revision => "2e26580ebcca4eca6533535f2dd062cd6bff44ac"
  end

  def install
    (buildpath/"src/github.com/mailhog/").mkpath
    ln_s buildpath, "#{buildpath}/src/github.com/mailhog/MailHog"

    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "build", "-o", "MailHog"
    bin.install "MailHog"
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/MailHog</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>StandardErrorPath</key>
      <string>#{var}/log/mailhog.log</string>
      <key>StandardOutPath</key>
      <string>#{var}/log/mailhog.log</string>
    </dict>
    </plist>
    EOS
  end

  test do
    pid = fork do
      exec "#{bin}/MailHog"
    end
    sleep 2

    begin
      output = shell_output("curl -s http://localhost:8025")
      assert_match %r{<title>MailHog</title>}, output
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
