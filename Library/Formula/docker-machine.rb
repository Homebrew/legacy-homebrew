require "language/go"

class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.docker.com/machine"
  url "https://github.com/docker/machine/archive/v0.5.4.tar.gz"
  sha256 "050640764c9f55e76b9475b04ebd9d6069e63cf7e2b54c2d07eda9254722d90e"
  head "https://github.com/docker/machine.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "06f9d8184bdde9a2522145680fc8c2d40c4c41bbe8b2ea84fea3c082c0e9fe7e" => :el_capitan
    sha256 "d4d07015cbaf4822361c8774a9da2f149ace1e69e9b222f7245f33a09a12123f" => :yosemite
    sha256 "95c69e57033c2d6539fd875e0759b71a7ff833334c9e2445b32b5eae420c31e4" => :mavericks
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
