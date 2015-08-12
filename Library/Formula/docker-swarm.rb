require "language/go"

class DockerSwarm < Formula
  desc "Turn a pool of Docker hosts into a single, virtual host"
  homepage "https://github.com/docker/swarm"
  url "https://github.com/docker/swarm/archive/v0.4.0.tar.gz"
  sha256 "c3ee1a34ce86da4d31f652c871dfa120fc78d5cc835e391034d740e83b48f7a3"

  head "https://github.com/docker/swarm.git"

  bottle do
    cellar :any
    sha256 "aae8957b821f820b9757e0cc962c4227cab0f0f4a1ecb19413f763a1e9659b9f" => :yosemite
    sha256 "a54e6021cb4c21a2df10d543d1a66ea071e5f2c201d58bd1f1e4f5d0aeb79257" => :mavericks
    sha256 "3b256069986b4bb9c65957c81d7debe915957b87402343aec72c1cf2dcc05559" => :mountain_lion
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
