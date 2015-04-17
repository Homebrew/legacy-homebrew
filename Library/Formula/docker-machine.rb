require "language/go"

class DockerMachine < Formula
  homepage "https://docs.docker.com/machine"
  url "https://github.com/docker/machine/archive/v0.1.0.tar.gz"
  sha256 "832f1e60b4171f9590368fa5c51c1ed1adec32367d13250a0554552d0954ff36"
  head "https://github.com/docker/machine.git"

  bottle do
    cellar :any
    sha256 "95bd096f70decc33ee58aaa78b13454e00ad841d6ffcf3aa37a4c42118f8abd7" => :yosemite
    sha256 "f2116f790e20a5c29395af2c2dd1799cb21475661e2289b618a401b3c246aa86" => :mavericks
    sha256 "d4555a7f47bfe42b847c00001dd11d124b71ad5cae69f9bcd14e1db1b8e0fe61" => :mountain_lion
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

  go_resource "github.com/docker/machine" do
    url "https://github.com/docker/machine.git", :revision => "eaff7635fc821d783eb6e996dbdad22dacdd058c"
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
