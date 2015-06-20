require "language/go"

class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.docker.com/machine"
  url "https://github.com/docker/machine/archive/v0.3.0.tar.gz"
  sha256 "fa1cbb8d806ca422b2c80b66952171875a2b092c9661baea7be11d5c60e279ac"
  head "https://github.com/docker/machine.git"

  bottle do
    cellar :any
    sha256 "523e8e7e1fc8789a6e874cd1df7c359248cb6acdbf34ed71a291484f9a47cf93" => :yosemite
    sha256 "435c2af2dea15dcd74c3f97a22dac85ce6991e962a12ab13e4f2c8a1c496c4e2" => :mavericks
    sha256 "7726970347097de7ad4ee919737c92ea48abebf060c781758c72182b6a3dae66" => :mountain_lion
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
