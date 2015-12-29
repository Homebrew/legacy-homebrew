class RancherCompose < Formula
  desc "Docker compose compatible client to deploy to Rancher"
  homepage "https://github.com/rancher/rancher-compose"
  url "https://github.com/rancher/rancher-compose/archive/v0.7.0.tar.gz"
  sha256 "0770ac1d73702a837f3aa45453edf51f1f1b8e9cdd5cf3d7cc9b48c0ed1e0fdd"

  bottle do
    cellar :any_skip_relocation
    sha256 "777f575af6c57321ff330778d726f5ee962faffded23c4cdbdb172b52c58a2d6" => :el_capitan
    sha256 "21038072075c7fc9c30e139d9cacbb61109a3636b49ca7abf68d76f5ca12aaed" => :yosemite
    sha256 "f52a0fd8601804b90ab50cc30243f5a1a73897ab776dd625de0bb9e2c0b043c7" => :mavericks
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
