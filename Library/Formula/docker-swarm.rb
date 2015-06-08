require "language/go"

class DockerSwarm < Formula
  desc "Turn a pool of Docker hosts into a single, virtual host"
  homepage "https://github.com/docker/swarm"
  url "https://github.com/docker/swarm/archive/v0.2.0.tar.gz"
  sha256 "7c9bb5b820f740e2963edc37cb0a2fc8160d42537870bf4caedb09036276008f"

  head "https://github.com/docker/swarm.git"

  bottle do
    cellar :any
    sha256 "b104c0a882af39060b3f0dc2859b4e72e4ce9802948681454848c79da87efb1f" => :yosemite
    sha256 "dc68ea1fd995fe9e5a8532c8ad10aae33079545896a67a3f669d75e374e3de22" => :mavericks
    sha256 "be2da9ac833e4283be4a0182d63ef19051aad23f0c3f8905c64d23f2a7205096" => :mountain_lion
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
