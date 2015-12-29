require "language/go"

class DockerMachineParallels < Formula
  desc "Docker Machine Parallels Driver"
  homepage "https://github.com/Parallels/docker-machine-parallels"
  url "https://github.com/Parallels/docker-machine-parallels/archive/v1.1.1.tar.gz"
  sha256 "a085bbc8c231f4629d3404677f73b49bff2414f7002f0e9acf9aee8cdae15829"
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
    url "https://github.com/docker/docker.git", :tag => "v1.9.1", :revision => "a34a1d598c6096ed8b5ce5219e77d68e5cd85462"
  end

  go_resource "github.com/docker/machine" do
    url "https://github.com/docker/machine.git", :tag => "v0.5.5", :revision => "02c4254cb4c93a4bbb5dc4ca0467abeb12d72546"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git", :revision => "f18420efc3b4f8e9f3d51f6bd2476e92c46260e9"
  end

  go_resource "github.com/codegangsta/cli" do
    url "https://github.com/codegangsta/cli.git", :tag => "v1.2.0", :revision => "565493f259bf868adb54d45d5f4c68d405117adf"
  end

  def install
    ENV["GOPATH"] = buildpath

    mkdir_p buildpath/"src/github.com/Parallels/"
    ln_sf buildpath, buildpath/"src/github.com/Parallels/docker-machine-parallels"
    Language::Go.stage_deps resources, buildpath/"src"

    system "godep", "go", "build", "-o", "./bin/docker-machine-driver-parallels", "./bin"
    bin.install "bin/docker-machine-driver-parallels"
  end

  test do
    assert_match "parallels-memory", shell_output("docker-machine create -d parallels -h")
  end
end
