class RancherCompose < Formula
  desc "Docker compose compatible client to deploy to Rancher"
  homepage "https://github.com/rancher/rancher-compose"
  url "https://github.com/rancher/rancher-compose/archive/v0.6.1.tar.gz"
  sha256 "45ae6623da4ebd6786118ae7c9f2a2ab33cec75bbd532fb70b1e89111681f800"

  bottle do
    cellar :any_skip_relocation
    sha256 "1a2278e00beaa9bd60d2d7f04284b8fe5e975e455b8987cbde4a0fb3d83c1360" => :el_capitan
    sha256 "a84153f40ab19ebc05bedef287d1118ba53332e3641b6342eeaf2259f2161a5c" => :yosemite
    sha256 "ee862b8cd9e7fd348490fb864a4e265950c114b4b7a64489490e07896b703ada" => :mavericks
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
