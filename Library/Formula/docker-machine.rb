require "language/go"

class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.docker.com/machine"
  url "https://github.com/docker/machine.git",
    :tag => "v0.6.0",
    :revision => "e27fb87286cb8e7454183ce46a6e1e84b31965e9"

  head "https://github.com/docker/machine.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d8f5419d5b9fdf3632e546190755d63df852fa89125b8bb68d932c3c30650286" => :el_capitan
    sha256 "b5b2a08a5295290799e7d352cb177659a64823ccea5ddc3246c04ece2c16e8d1" => :yosemite
    sha256 "ef3a096090e2abf7cae56f52b9d4f5aed14cc79ae534d4fd21ff5b11be159cd5" => :mavericks
  end

  depends_on "go" => :build
  depends_on "automake" => :build

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
    assert_match /#{version}/, shell_output(bin/"docker-machine --version")
  end
end
