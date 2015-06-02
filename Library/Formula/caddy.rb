require "language/go"

class Caddy < Formula
  homepage "https://caddyserver.com/"
  url "https://github.com/mholt/caddy/archive/v0.6.0.tar.gz"
  sha256 "919023cd91b6ab94fcde08fc30620b10f90eaaa95ab8b9f3ff7e06c0e9b7f301"
  desc "Alternative general-purpose HTTP/2 web server"

  bottle do
    cellar :any
    sha256 "fa5e8abd8a6f756c8eac243eff986f5359d7bac4cf8aa101ef4abcfd7663c852" => :yosemite
    sha256 "bf4fb487f503e51af2f9bc48badd09bec452113d1a60caa1ccb2ab7fa6d5699e" => :mavericks
    sha256 "6e5f7d9348505a970aa6369091b447ae203c3808185ba993a967d5d9e185841f" => :mountain_lion
  end

  depends_on "go" => :build

  head do
    url "https://github.com/mholt/caddy.git"

    go_resource "gopkg.in/yaml.v2" do
      url "https://gopkg.in/yaml.v2.git"
    end

    go_resource "github.com/BurntSushi/toml" do
      url "https://github.com/BurntSushi/toml.git", :revision => "056c9bc7be7190eaa7715723883caffa5f8fa3e4"
    end
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git", :revision => "e0403b4e005737430c05a57aac078479844f919c"
  end

  go_resource "github.com/bradfitz/http2" do
    url "https://github.com/bradfitz/http2.git", :revision => "f8202bc903bda493ebba4aa54922d78430c2c42f"
  end

  go_resource "github.com/dustin/go-humanize" do
    url "https://github.com/dustin/go-humanize.git", :revision => "00897f070f09f194c26d65afae734ba4c32404e8"
  end

  go_resource "github.com/flynn/go-shlex" do
    url "https://github.com/flynn/go-shlex.git", :revision => "70644ac2a65dbf1691ce00c209d185163a14edc6"
  end

  go_resource "github.com/russross/blackfriday" do
    url "https://github.com/russross/blackfriday.git", :revision => "4bed88b4fd00fbb66b49b0f38ed3dd0b902ab515"
  end

  go_resource "github.com/shurcooL/sanitized_anchor_name" do
    url "https://github.com/shurcooL/sanitized_anchor_name.git", :revision => "8e87604bec3c645a4eeaee97dfec9f25811ff20d"
  end

  def install
    mkdir_p buildpath/"src/github.com/mholt/"
    ln_s buildpath, buildpath/"src/github.com/mholt/caddy"
    ENV["GOPATH"] = buildpath
    ENV["GOOS"] = "darwin"
    ENV["GOARCH"] = MacOS.prefer_64_bit? ? "amd64" : "386"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "caddy"
    bin.install "caddy"
    doc.install %w[README.md LICENSE.md]
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
