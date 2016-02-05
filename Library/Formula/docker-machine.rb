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
    sha256 "0998550c7e142579885924ad826b12c094f8f2ba19eac9be06fb49b21f355f65" => :el_capitan
    sha256 "6ae72763df1ad7f7dbacf544b2e50d0e65cd3b7c461a6deabbfe3ccd518a2c7f" => :yosemite
    sha256 "9c2226f22133abf2fe10ea5f564d0c5e31be21f5f3bed813776d0a1dca9fc98a" => :mavericks
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
