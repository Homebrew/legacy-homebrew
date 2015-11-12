require "language/go"

class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/0.0.16.tar.gz"
  sha256 "4f4805f36fd0d437331c25a183471419d10a680721f7f5a890b4109319d605ed"
  head "https://github.com/digitalocean/doctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f8cb3382b89b2b5250211462d3d25682cfcf78118a6bcb4a71be7178ef0d7603" => :el_capitan
    sha256 "732cfe89d343767b7323cbd3066e3cacc279bb0e264b3ad819fefda946c8ce87" => :yosemite
    sha256 "c8a02718eb9e460414a4dee18ec328f3d439000c7e86885768734f00819883d1" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/tools/godep" do
    url "https://github.com/tools/godep.git", :revision => "58d90f262c13357d3203e67a33c6f7a9382f9223"
  end

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
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/digitalocean/"
    ln_sf buildpath, buildpath/"src/github.com/digitalocean/doctl"
    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/tools/godep" do
      system "go", "install"
    end
    ENV["GOPATH"] = buildpath/"src/github.com/digitalocean/doctl/Godeps/_workspace"
    system "./bin/godep", "restore"
    system "./bin/godep", "go", "build", "-o", "doctl", "."
    bin.install "doctl"
  end

  test do
    system bin/"doctl", "help"
  end
end
