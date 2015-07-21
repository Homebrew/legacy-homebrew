require "language/go"

class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.docker.com/machine"
  url "https://github.com/docker/machine/archive/v0.3.1.tar.gz"
  sha256 "9afc45f5d0f77c2e96efbc3799b7e7e4d079c01aadcc5cb5d7ef831b855ccf58"
  head "https://github.com/docker/machine.git"

  bottle do
    cellar :any
    sha256 "2854da1a321dfff6c71aa3edc69fb873c4404014127273b5bd77fe6f7e85fb9b" => :yosemite
    sha256 "57d8144637972f356f00caf4b04b843173f56d5e53b4429ce85f02c21d7c8c32" => :mavericks
    sha256 "e23f351ceccc110c884acd07520f090fe0943a994ae97ffc14a613cfc2f85301" => :mountain_lion
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

  go_resource "github.com/pmezard/go-difflib/difflib" do
    url "https://github.com/pmezard/go-difflib.git", :revision => "f78a839676152fd9f4863704f5d516195c18fc14"
  end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/docker/"
    ln_sf buildpath, buildpath/"src/github.com/docker/machine"
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
