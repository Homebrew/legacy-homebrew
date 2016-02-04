require "language/go"

class DockerSwarm < Formula
  desc "Turn a pool of Docker hosts into a single, virtual host"
  homepage "https://github.com/docker/swarm"
  url "https://github.com/docker/swarm/archive/v1.1.0.tar.gz"
  sha256 "463aa579a0c43f2874bb14f37bac0ce4ae233672f84360d398a206d18e706cf5"

  head "https://github.com/docker/swarm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "10b1cea4a97d95d2c7ca82f450e30be10b624e078b87486a6ab633239879ea83" => :el_capitan
    sha256 "0d8c81a702652bc8182e10c58789db71217da8a649ef45db3219f402f2c2c0b6" => :yosemite
    sha256 "530afec739c621c8cd792079741d157117efde7933e03fd344622b590cdeda92" => :mavericks
  end

  depends_on "go" => :build

  def install
    mkdir_p buildpath/"src/github.com/docker"
    ln_s buildpath, buildpath/"src/github.com/docker/swarm"

    ENV["GOPATH"] = "#{buildpath}/Godeps/_workspace:#{buildpath}"

    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "docker-swarm"
    bin.install "docker-swarm"
  end

  test do
    output = shell_output(bin/"docker-swarm --version")
    assert_match "swarm version #{version} (HEAD)", output
  end
end
