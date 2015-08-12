require "language/go"

class DockerSwarm < Formula
  desc "Turn a pool of Docker hosts into a single, virtual host"
  homepage "https://github.com/docker/swarm"
  url "https://github.com/docker/swarm/archive/v0.4.0.tar.gz"
  sha256 "c3ee1a34ce86da4d31f652c871dfa120fc78d5cc835e391034d740e83b48f7a3"

  head "https://github.com/docker/swarm.git"

  bottle do
    cellar :any
    sha256 "6a8a15a511cd1bf5f10c9e53af8784d06d51fdd359ab533dfe8daaa7a6c872b3" => :yosemite
    sha256 "33f60f41343326f549c886ed60564a1672877f77c8636962d8c4c47c10d62f05" => :mavericks
    sha256 "e6b63640e4ff88d073c0449ea23a3c8c3ff46caffc72c3e4d4a2e159ffade10d" => :mountain_lion
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
