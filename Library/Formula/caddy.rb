require "language/go"

class Caddy < Formula
  desc "Alternative general-purpose HTTP/2 web server"
  homepage "https://caddyserver.com/"
  url "https://github.com/mholt/caddy/archive/v0.8.0.tar.gz"
  sha256 "c7650e8772b8b19cbe5aca1c51898c053c9df397237e54f671cee8780f21d741"
  head "https://github.com/mholt/caddy.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "42f193d8198defa82104f5a14a351373bec0c380809b5dcab96ee66dbc1fd941" => :el_capitan
    sha256 "50989f247c3ef052bb6292897904d11f48c2551f70b09805a8789d526dd77061" => :yosemite
    sha256 "a6c652d74658ecb21dc801f6c504aa6a5287aebdc042ee302b71ff471710ccd1" => :mavericks
  end

  depends_on "go" => :build

  go_resource "gopkg.in/yaml.v2" do
    url "https://github.com/go-yaml/yaml.git",
        :branch => "v2",
        :revision => "bec87e4332aede01fb63a4ab299d8af28480cd96"
  end

  go_resource "github.com/BurntSushi/toml" do
    url "https://github.com/BurntSushi/toml.git", :revision => "056c9bc7be7190eaa7715723883caffa5f8fa3e4"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git", :revision => "943b8c241accc9aa2b2a91735b28aea7f26765cb"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git", :revision => "7b85b097bf7527677d54d3220065e966a0e3b613"
  end

  go_resource "github.com/bradfitz/http2" do
    url "https://github.com/bradfitz/http2.git", :revision => "f8202bc903bda493ebba4aa54922d78430c2c42f"
  end

  go_resource "github.com/dustin/go-humanize" do
    url "https://github.com/dustin/go-humanize.git", :revision => "c128122e0b9b93799aef8181a537e5d8fd7081d6"
  end

  go_resource "github.com/flynn/go-shlex" do
    url "https://github.com/flynn/go-shlex.git", :revision => "3f9db97f856818214da2e1057f8ad84803971cff"
  end

  go_resource "github.com/russross/blackfriday" do
    url "https://github.com/russross/blackfriday.git", :revision => "8cec3a854e68dba10faabbe31c089abf4a3e57a6"
  end

  go_resource "github.com/shurcooL/sanitized_anchor_name" do
    url "https://github.com/shurcooL/sanitized_anchor_name.git", :revision => "11a20b799bf22a02808c862eb6ca09f7fb38f84a"
  end

  go_resource "github.com/hashicorp/go-syslog" do
    url "https://github.com/hashicorp/go-syslog.git", :revision => "42a2b573b664dbf281bd48c3cc12c086b17a39ba"
  end

  go_resource "github.com/gorilla/websocket" do
    url "https://github.com/gorilla/websocket.git", :revision => "844dd6d40e1a9215ef4c8a204bfc839fcf5dd5dd"
  end

  go_resource "github.com/jimstudt/http-authentication" do
    url "https://github.com/jimstudt/http-authentication.git", :revision => "3eca13d6893afd7ecabe15f4445f5d2872a1b012"
  end

  go_resource "github.com/xenolf/lego" do
    url "https://github.com/xenolf/lego.git", :revision => "bf740fa2cafb7d6deb0911792a13f37ef5995a03"
  end

  go_resource "gopkg.in/natefinch/lumberjack.v2" do
    url "https://github.com/natefinch/lumberjack.git", :revision => "600ceb4523e5b7ff745f91083c8a023c2bf73af5"
  end

  go_resource "github.com/square/go-jose" do
    url "https://github.com/square/go-jose.git", :revision => "37934a899dd03635373fd1e143936d32cfe48d31"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOOS"] = "darwin"
    ENV["GOARCH"] = MacOS.prefer_64_bit? ? "amd64" : "386"

    mkdir_p buildpath/"src/github.com/mholt/"
    ln_s buildpath, buildpath/"src/github.com/mholt/caddy"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", bin/"caddy"
    doc.install %w[README.md LICENSE.txt]
  end

  test do
    begin
      io = IO.popen("#{bin}/caddy")
      sleep 2
    ensure
      Process.kill("SIGINT", io.pid)
      Process.wait(io.pid)
    end

    io.read =~ /0\.0\.0\.0:2015/
  end
end
