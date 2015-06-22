require "language/go"

class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.docker.com/machine"
  url "https://github.com/docker/machine/archive/v0.3.0.tar.gz"
  sha256 "fa1cbb8d806ca422b2c80b66952171875a2b092c9661baea7be11d5c60e279ac"
  head "https://github.com/docker/machine.git"

  bottle do
    cellar :any
    revision 1
    sha256 "fd11d54736c42f3a48b769f159bb597bd709aefae6b529b27265e69640ec70f1" => :yosemite
    sha256 "d164512ef8cfb69d8740d73219b2d6d32726741122486b93553874986c4184c6" => :mavericks
    sha256 "fd956c59b9c08ab4723487c9f4e120ea3017e90ea43b741f0330318d40c73892" => :mountain_lion
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

  go_resource "github.com/pmezard/go-difflib/difflib" do
    url "https://github.com/pmezard/go-difflib.git", :revision => "f78a839676152fd9f4863704f5d516195c18fc14"
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
