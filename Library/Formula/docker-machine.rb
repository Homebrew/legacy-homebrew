require "language/go"

class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.docker.com/machine"
  url "https://github.com/docker/machine/archive/v0.5.6.tar.gz"
  sha256 "b6dee30f6e8eb1d3f130cbd9545018e0abb514a968bcd1acd6006ae343f8f402"
  head "https://github.com/docker/machine.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "07415b59f32d1784860ea71840ec2c3f1a6bb5280f9a08bb5cd54bebd87b8a35" => :el_capitan
    sha256 "f0d003873e2c231bef1d5342b3d70bac8e356a0cfbe3055372ff221b63157a14" => :yosemite
    sha256 "2ab934dad9b01dd80f6ee6a5ea2c22b82461815b29b69425e04486483d457789" => :mavericks
  end

  depends_on "go" => :build
  depends_on "automake" => :build

  go_resource "github.com/codegangsta/cli" do
    url "https://github.com/codegangsta/cli.git",
      :revision => "bca61c476e3c752594983e4c9bcd5f62fb09f157"
  end

  def install
    ENV["GOBIN"] = bin
    ENV["GOPATH"] = buildpath
    ENV["GOHOME"] = buildpath

    path = buildpath/"src/github.com/docker/machine"
    path.install Dir["*"]

    Language::Go.stage_deps resources, buildpath/"src"

    cd path do
      system "make", "build"
      bin.install Dir["bin/*"]
      bash_completion.install Dir["contrib/completion/bash/*.bash"]
    end
  end

  test do
    system bin/"docker-machine", "ls"
  end
end
