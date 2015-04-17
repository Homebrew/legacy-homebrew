require "language/go"

class DockerSwarm < Formula
  homepage "https://github.com/docker/swarm"
  url "https://github.com/docker/swarm/archive/v0.2.0.tar.gz"
  sha256 "7c9bb5b820f740e2963edc37cb0a2fc8160d42537870bf4caedb09036276008f"

  head "https://github.com/docker/swarm.git"

  bottle do
    cellar :any
    sha256 "3f67608ae690346300ca8fd91fb6d669915e3d83019e26911eef6932eb915dee" => :yosemite
    sha256 "aebf5eb365027a12691fba02f53cae0e13f43102813e5b371b7ba17ae4ab8ed9" => :mavericks
    sha256 "4b7ae391c7a88fc6e20c93ce10648015d24e5ef1a0e7e25d34fc44642427afe3" => :mountain_lion
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
    assert output.include? "swarm version 0.2.0 (HEAD)"
  end
end
