require "language/go"

class DockerMachineParallels < Formula
  desc "Docker Machine Parallels Driver"
  homepage "https://github.com/Parallels/docker-machine-parallels"
  url "https://github.com/Parallels/docker-machine-parallels/archive/v1.1.0.tar.gz"
  sha256 "0f2ccc1c470a71b40e81b548b4587cdcbc098f0ceeea6295ec8bebbb06aa9135"
  head "https://github.com/Parallels/docker-machine-parallels.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1e07e344fba14561f64c27d4822af244c1b4ea0245d9af29a61031e4fc71be6a" => :el_capitan
    sha256 "86b96ffe41ef992f3b71737896b77ac93e5663e40cebba0e56e0c7198ffeca6b" => :yosemite
    sha256 "1f434e04a3715bb0ea9f1138c99822205fd38c72972c7edfced37b0553054895" => :mavericks
  end

  depends_on "go" => :build
  depends_on "godep" => :build
  depends_on "docker-machine"

  go_resource "github.com/docker/docker" do
    # Docker v1.9.1 release
    url "https://github.com/docker/docker.git", :revision => "a34a1d598c6096ed8b5ce5219e77d68e5cd85462"
  end

  go_resource "github.com/docker/machine" do
    # Docker Machine v0.5.1 release
    url "https://github.com/docker/machine.git", :revision => "7e8e38e1485187c0064e054029bb1cc68c87d39a"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git", :revision => "beef0f4390813b96e8e68fd78570396d0f4751fc"
  end

  def install
    ENV["GOPATH"] = buildpath

    mkdir_p buildpath/"src/github.com/Parallels/"
    ln_sf buildpath, buildpath/"src/github.com/Parallels/docker-machine-parallels"
    Language::Go.stage_deps resources, buildpath/"src"

    system "godep", "go", "build", "-i", "-o", "./bin/docker-machine-driver-parallels", "./bin"
    bin.install "bin/docker-machine-driver-parallels"
  end

  test do
    assert_match "parallels-memory", shell_output("docker-machine create -d parallels -h")
  end
end
