require "language/go"

class DockerSwarm < Formula
  desc "Turn a pool of Docker hosts into a single, virtual host"
  homepage "https://github.com/docker/swarm"
  url "https://github.com/docker/swarm/archive/v1.1.0.tar.gz"
  sha256 "463aa579a0c43f2874bb14f37bac0ce4ae233672f84360d398a206d18e706cf5"

  head "https://github.com/docker/swarm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6cf0f7d3ee5421369fa855affe55aaf745c874a79050d689c51bc8a3d24dca62" => :el_capitan
    sha256 "bdafde632054ee4cea15ed48206f672a28a915a299749529f387a20e82888420" => :yosemite
    sha256 "b4059a738384817cf61af5e352a448c10ca0a8533642581dfae24390f9eeb448" => :mavericks
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
