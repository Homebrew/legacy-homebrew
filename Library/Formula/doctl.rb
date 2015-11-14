require "language/go"

class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/0.0.16.tar.gz"
  sha256 "4f4805f36fd0d437331c25a183471419d10a680721f7f5a890b4109319d605ed"
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "c7f115393c78e32d2073843330e3ab199e721c58d7f322aa9f9dd49dcaade82a" => :el_capitan
    sha256 "2e7fe1da197114a7e3398c21a39e6731396233e9c45bb5526bf0bdf63d0ae15e" => :yosemite
    sha256 "e4dd84c4b011dea5f9e0872f95eaaa5491543bc47e0db0fd35a294dd81cb5f39" => :mavericks
  end

  depends_on "go" => :build
  depends_on "godep" => :build

  go_resource "github.com/kr/fs" do
    url "https://github.com/kr/fs.git", :revision => "2788f0dbd16903de03cb8186e5c7d97b69ad387b"
  end

  go_resource "golang.org/x/tools" do
    url "https://github.com/golang/tools.git", :revision => "473fd854f8276c0b22f17fb458aa8f1a0e2cf5f5"
  end

  go_resource "golang.org/x/crypto" do
    url "https://github.com/golang/crypto.git", :revision => "8b27f58b78dbd60e9a26b60b0d908ea642974b6d"
  end

  def install
    ENV["GOPATH"] = buildpath/"src/github.com/digitalocean/doctl/Godeps/_workspace"
    mkdir_p buildpath/"src/github.com/digitalocean/"
    ln_sf buildpath, buildpath/"src/github.com/digitalocean/doctl"
    Language::Go.stage_deps resources, buildpath/"src"

    system "godep", "restore"
    system "godep", "go", "build", "-o", "doctl", "."
    bin.install "doctl"
  end

  test do
    system bin/"doctl", "help"
  end
end
