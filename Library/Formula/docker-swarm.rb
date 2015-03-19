require "language/go"

class DockerSwarm < Formula
  homepage "https://github.com/docker/swarm"
  url "https://github.com/docker/swarm/archive/v0.1.0.tar.gz"
  sha256 "a9e1f68138b2e93030e4e283345b5c850c9c41eab95b6ad645ac2cc735270c32"

  bottle do
    cellar :any
    sha256 "3f67608ae690346300ca8fd91fb6d669915e3d83019e26911eef6932eb915dee" => :yosemite
    sha256 "aebf5eb365027a12691fba02f53cae0e13f43102813e5b371b7ba17ae4ab8ed9" => :mavericks
    sha256 "4b7ae391c7a88fc6e20c93ce10648015d24e5ef1a0e7e25d34fc44642427afe3" => :mountain_lion
  end

  depends_on "go" => :build

  go_resource "github.com/tools/godep" do
    url "https://github.com/tools/godep.git", :revision => "58d90f262c13357d3203e67a33c6f7a9382f9223"
  end

  go_resource "github.com/kr/fs" do
    url "https://github.com/kr/fs.git", :revision => "2788f0dbd16903de03cb8186e5c7d97b69ad387b"
  end

  go_resource "golang.org/x/tools" do
    url "https://github.com/golang/tools.git", :revision => "473fd854f8276c0b22f17fb458aa8f1a0e2cf5f5"
  end

  go_resource "github.com/docker/swarm" do
    url "https://github.com/docker/swarm.git", :revision => "2acbea1149842e2b577c752b6c3eee17e0a0489e"
  end

  def install
    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/tools/godep" do
      system "go", "install"
    end

    system "./bin/godep", "go", "build", "-o", "docker-swarm", "."
    bin.install "docker-swarm"
  end

  test do
    output = shell_output("#{bin}/docker-swarm --version")
    assert output.include? "swarm version 0.1.0 (HEAD)"
  end
end
