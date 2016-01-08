require "language/go"

class DockerSwarm < Formula
  desc "Turn a pool of Docker hosts into a single, virtual host"
  homepage "https://github.com/docker/swarm"
  url "https://github.com/docker/swarm/archive/v1.0.0.tar.gz"
  sha256 "85951f91a2e3b6b82ac775bafce3fc76dd29aa2cdeb6a3ad84a97116fd72d2d8"

  head "https://github.com/docker/swarm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "82c2d64fcc9893f077244eaee10cc76d27fad5f7ae250d6e2cd4d9ac73b85dc4" => :el_capitan
    sha256 "652c451d30e33987c2607d86b62387a1373ec4d48b1861e5c34ff0d17d96ff3d" => :yosemite
    sha256 "77401660d38f872dd0f2abc548fb67f927f49e8233f3651dfd6b0568bb508838" => :mavericks
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
