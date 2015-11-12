require "language/go"

class DockerMachineParallels < Formula
  desc "Docker Machine Parallels Driver"
  homepage "https://github.com/Parallels/docker-machine-parallels"
  url "https://github.com/Parallels/docker-machine-parallels/archive/v1.0.1.tar.gz"
  sha256 "9a5abc454748aeb83c74c45efd3a73359a47e408e215318fbcc6446026581652"
  head "https://github.com/Parallels/docker-machine-parallels.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "44650aa4e70e2c7d53c3480150cd4733cdde9959c836f520517a7ff3a9335544" => :el_capitan
    sha256 "b3b09d60c173542970dbaa0257bbdaf54520b229df2135284f534f952d121b39" => :yosemite
    sha256 "575cd941ec602f32cdb0b66910009ecf6d20212a327df2c0143ef051c7db7b74" => :mavericks
  end

  depends_on "go" => :build
  depends_on "docker-machine"

  go_resource "github.com/docker/docker" do
    url "https://github.com/docker/docker.git", :revision => "76d6bc9a9f1690e16f3721ba165364688b626de2"
  end

  go_resource "github.com/docker/machine" do
    url "https://github.com/docker/machine.git", :revision => "04cfa58445f063509699cdde41080a410330c4df"
  end

  go_resource "golang.org/x/crypto" do
    url "https://github.com/golang/crypto.git", :revision => "8b27f58b78dbd60e9a26b60b0d908ea642974b6d"
  end

  def install
    ENV["GOPATH"] = buildpath

    mkdir_p buildpath/"src/github.com/Parallels/"
    ln_sf buildpath, buildpath/"src/github.com/Parallels/docker-machine-parallels"
    Language::Go.stage_deps resources, buildpath/"src"

    system "make", "build"
    bin.install "bin/docker-machine-driver-parallels"
  end

  test do
    assert_match "parallels-memory", shell_output("docker-machine create -d parallels -h")
  end
end
