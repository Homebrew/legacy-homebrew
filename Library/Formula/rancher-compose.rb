class RancherCompose < Formula
  desc "Docker compose compatible client to deploy to Rancher"
  homepage "https://github.com/rancher/rancher-compose"
  url "https://github.com/rancher/rancher-compose/archive/v0.7.0.tar.gz"
  sha256 "0770ac1d73702a837f3aa45453edf51f1f1b8e9cdd5cf3d7cc9b48c0ed1e0fdd"

  bottle do
    cellar :any_skip_relocation
    sha256 "50ca4094552d238b3522168c197bcb07dded27c9bae3d61d9879483a4fe95585" => :el_capitan
    sha256 "afe860f4f187a644798b659a499f561cb2bd3fc69bd1f9bab1d3c828bc43892f" => :yosemite
    sha256 "52a2d5cb64d3f668444df3dd619d6a0910fbb90df29990f3ca35205dd626930d" => :mavericks
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
