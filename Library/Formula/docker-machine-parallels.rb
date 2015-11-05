require "language/go"

class DockerMachineParallels < Formula
  desc "Docker Machine Parallels Driver"
  homepage "https://github.com/Parallels/docker-machine-parallels"
  url "https://github.com/Parallels/docker-machine-parallels/archive/v1.0.0.tar.gz"
  sha256 "2598ced93c8dec6eaccacca1b0c72275c423a2afbf34d88bdc4173475bdcc5cf"
  head "https://github.com/Parallels/docker-machine-parallels.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cf512918306a8ce4f3b2f9686d040b871b2981353579713fff52d108de8c87e8" => :el_capitan
    sha256 "1caf0c6146c574295442efd1cddd23c4a9bab5aade7f3c1233408c79413bd852" => :yosemite
    sha256 "1be969fb8f690f804eb4dbc11e1a7a70a7be794763f351f5b9a800a20ea08903" => :mavericks
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
