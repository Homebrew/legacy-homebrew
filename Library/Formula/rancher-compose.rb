class RancherCompose < Formula
  desc "Docker compose compatible client to deploy to Rancher"
  homepage "https://github.com/rancher/rancher-compose"
  url "https://github.com/rancher/rancher-compose/archive/v0.5.0.tar.gz"
  sha256 "5d26bdbd34ac7bcf9fdc3a7b1129e25cd8dd72368fc89cf699ec2c1d9f134002"

  bottle do
    cellar :any_skip_relocation
    sha256 "f3e90b72e1345a1ebbccfcf381a6d3f6fa0a85173f30b43d91502b84246b5f7a" => :el_capitan
    sha256 "c8f468955b8dd3233ac82f9f5a42bac1e6a9c9649623d5ec4a4df025bad3977b" => :yosemite
    sha256 "797c19e6ed32d8c4f28291cf1e9fee9504fd5d42e5c3175fa276b494e4f4877f" => :mavericks
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
