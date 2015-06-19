require "language/go"

class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.docker.com/machine"
  url "https://github.com/docker/machine/archive/v0.3.0.tar.gz"
  sha256 "fa1cbb8d806ca422b2c80b66952171875a2b092c9661baea7be11d5c60e279ac"
  head "https://github.com/docker/machine.git"

  bottle do
    cellar :any
    sha256 "3c4f95abe4ea2f9fe3f74675fe4a615a7e0dacc5b19fd8736890ef8f7986ed76" => :yosemite
    sha256 "dccb6caa7f58f2bdc38c1c9d4b4e7cf6344caeb64228b5292ea00066bbffd74e" => :mavericks
    sha256 "ed22e427b1ecb3965eac5184951d807c4ec91e49eb17997bbc10b1987e0450c4" => :mountain_lion
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

  go_resource "github.com/Sirupsen/logrus" do
    url "https://github.com/Sirupsen/logrus.git", :revision => "21d4508646ae56d79244bd9046c1df63a5fa8c37"
  end

  go_resource "github.com/docker/machine" do
    url "https://github.com/docker/machine.git", :revision => "0a251fe434d868165cca28200ffd71f16abb5c10" # the 0.3.0 tag
  end

  def install
    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/tools/godep" do
      system "go", "install"
    end

    system "./bin/godep", "go", "build", "-o", "docker-machine", "."
    bin.install "docker-machine"
  end

  test do
    system bin/"docker-machine", "ls"
  end
end
