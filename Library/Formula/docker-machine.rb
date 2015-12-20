require "language/go"

class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.docker.com/machine"
  url "https://github.com/docker/machine/archive/v0.5.4.tar.gz"
  sha256 "050640764c9f55e76b9475b04ebd9d6069e63cf7e2b54c2d07eda9254722d90e"
  head "https://github.com/docker/machine.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "49079c3480844940857b15c7cc67a51375b3dd11b3f4cb6e5011ebec325db209" => :el_capitan
    sha256 "6b29398cde25169d09a10724da58750109a659f5c539f3a61df01073c48aaec6" => :yosemite
    sha256 "12631a5d4ed753a71f9db2860d38d938f45aa168c8ffb895b06c1fcf752ad49c" => :mavericks
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
    end

    bash_completion.install Dir["contrib/completion/bash/*.bash"]
  end

  test do
    system bin/"docker-machine", "ls"
  end
end
