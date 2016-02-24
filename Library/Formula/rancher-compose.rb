class RancherCompose < Formula
  desc "Docker Compose compatible client to deploy to Rancher"
  homepage "https://github.com/rancher/rancher-compose"
  url "https://github.com/rancher/rancher-compose/archive/v0.7.2.tar.gz"
  sha256 "17378457a4abb1ceec2cac3001783990b17c53606df40908498537bec458cce2"

  bottle do
    cellar :any_skip_relocation
    sha256 "e7b09f34ca7701bb860e579d5501ee4aacd5d1c0affbf1feefd5747ff68d64e9" => :el_capitan
    sha256 "705a15cf034d762fcd68040e3dee9201214dbffc09dbf68ead1e26b969c57c00" => :yosemite
    sha256 "39453b69120eeaf947f3ccff9213ca50727575ef3485610fff186e875cca4119" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = "#{buildpath}:#{buildpath}/Godeps/_workspace"
    mkdir_p "#{buildpath}/src/github.com/rancher"
    ln_s buildpath, "#{buildpath}/src/github.com/rancher/rancher-compose"
    system "go", "build", "-ldflags", "-w -X github.com/rancher/rancher-compose/version.VERSION #{version}", "-o", "#{bin}/rancher-compose"
  end

  test do
    system "#{bin}/rancher-compose", "help"
  end
end
