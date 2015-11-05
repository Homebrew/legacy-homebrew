require "language/go"

class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.docker.com/machine"
  url "https://github.com/docker/machine/archive/v0.5.0.tar.gz"
  sha256 "35f2c9e95b962caf5557e6f1458fbf4ac85253a92ed04d3ace0f958a9e3c9676"
  head "https://github.com/docker/machine.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "67d4b405869998b34cf06c34e678b2da6636886e6698d8a2219676b925619940" => :el_capitan
    sha256 "60065417d18cd33ec395c475b7f48be55a4fccf294a78d122e749457cd6c7172" => :yosemite
    sha256 "b4356336303475db65b5a5d0464b53730205d9d6de79064d67c1f6f9b6def0a9" => :mavericks
  end

  depends_on "go" => :build
  depends_on "automake" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/docker/"
    ln_sf buildpath, buildpath/"src/github.com/docker/machine"

    system "make", "build"
    bin.install Dir["bin/*"]
  end

  test do
    system bin/"docker-machine", "ls"
  end
end
