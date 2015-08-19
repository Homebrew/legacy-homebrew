require "language/go"

class Caddy < Formula
  desc "Alternative general-purpose HTTP/2 web server"
  homepage "https://caddyserver.com/"
  url "https://github.com/mholt/caddy/archive/v0.7.5.tar.gz"
  sha256 "3e322497466f1706c85a214095e645b2d4340ce83961ebd370178fbf840253bd"
  head "https://github.com/mholt/caddy.git"

  bottle do
    cellar :any
    sha256 "bb91e6fdf8214ced695a79d8a4b1c1bf30612f24cb46119f8eaf9479edbe9da8" => :yosemite
    sha256 "638006bfc8db6721e692be399d9250dcc01194e43765e2ef5aeed7c4f00c3f89" => :mavericks
    sha256 "6a89643de7a9f61435e9a27838f095d0fa1616ef11b9fcfafb0d94980921e763" => :mountain_lion
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
    url "https://go.googlesource.com/net.git", :revision => "e0403b4e005737430c05a57aac078479844f919c"
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
