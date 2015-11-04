require "language/go"

class DockerMachineParallels < Formula
  desc "Docker Machine Parallels Driver"
  homepage "https://github.com/Parallels/docker-machine-parallels"
  url "https://github.com/Parallels/docker-machine-parallels/archive/v1.0.0.tar.gz"
  sha256 "2598ced93c8dec6eaccacca1b0c72275c423a2afbf34d88bdc4173475bdcc5cf"
  head "https://github.com/Parallels/docker-machine-parallels.git"

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
