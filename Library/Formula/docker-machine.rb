require "language/go"

class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.docker.com/machine"
  url "https://github.com/docker/machine/archive/v0.4.1.tar.gz"
  sha256 "f089657b2de7a3ce15374e69be3f654b0866f75eb077ca363f8a5933ccf51cda"
  head "https://github.com/docker/machine.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1999548d84ddade819c21e6b6bc89f4590d20efed575a8996e9e87398afd3458" => :el_capitan
    sha256 "ec656857e23724204cb94cf6eea10feb887b9db0ae6027c751b95ae62e77d315" => :yosemite
    sha256 "4890545e0d50d8920394803313b95af81368414aa3a27f3fa16475e4fe9b69a7" => :mavericks
    sha256 "f282138ad3860b2b05c86f1a070c6fe3722220ea358c61ece16e8098b0798430" => :mountain_lion
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
