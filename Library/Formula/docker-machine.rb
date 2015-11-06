require "language/go"

class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.docker.com/machine"
  url "https://github.com/docker/machine/archive/v0.5.0.tar.gz"
  sha256 "35f2c9e95b962caf5557e6f1458fbf4ac85253a92ed04d3ace0f958a9e3c9676"
  head "https://github.com/docker/machine.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "f628b6d048aa0b27887c6dfffbc7df2bcbe3a76986773ee9e4930bae88ad4e94" => :el_capitan
    sha256 "39f62a9ff38cffaba409304ea5ea2bf6d7dafa23fa37f4573d72b31cd517c9ff" => :yosemite
    sha256 "01ac8d8de1389f2f28a00af8e9a772addbd3141ccdf8087f285d00cc51058285" => :mavericks
  end

  depends_on "go" => :build
  depends_on "automake" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/docker/"
    ln_sf buildpath, buildpath/"src/github.com/docker/machine"

    system "make", "build"
    bin.install Dir["bin/*"]

    bash_completion.install Dir["contrib/completion/bash/*.bash"]
  end

  test do
    system bin/"docker-machine", "ls"
  end
end
