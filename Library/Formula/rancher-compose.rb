class RancherCompose < Formula
  desc "Docker compose compatible client to deploy to Rancher"
  homepage "https://github.com/rancher/rancher-compose"
  url "https://github.com/rancher/rancher-compose/archive/v0.6.1.tar.gz"
  sha256 "45ae6623da4ebd6786118ae7c9f2a2ab33cec75bbd532fb70b1e89111681f800"

  bottle do
    cellar :any_skip_relocation
    sha256 "0a6a93d927554f4c97afad2b5ceafab1339f1acc44d73298b9e8a86d3ae8199d" => :el_capitan
    sha256 "b4b6970277e0a7576172563085469369dfd761214dfd17f746efce05bdec9073" => :yosemite
    sha256 "2554c6051f5f46f2a376fb8521d55b6cd95ad75d263db38c29f06a87ddd824bd" => :mavericks
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
