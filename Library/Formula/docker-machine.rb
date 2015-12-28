require "language/go"

class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.docker.com/machine"
  url "https://github.com/docker/machine/archive/v0.5.5.tar.gz"
  sha256 "106a804491120bfc9da8a2229b4ce33b4d99210ada0b4ad4f6e1590f81eef8d8"
  head "https://github.com/docker/machine.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "cabf289587f3a24e87e27aa96b100e7696159a847ab2c5d825cbd0f6c150bb8a" => :el_capitan
    sha256 "f8fcf2aeec09de57d577fb2730f24966866e28b5ae52c781ed21827a84f2a799" => :yosemite
    sha256 "ff6e326bb360e0dfe80d36e3408bb0785c235c908b34dac72005e40e0f81eae2" => :mavericks
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
