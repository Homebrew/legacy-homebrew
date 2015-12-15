class RancherCompose < Formula
  desc "Docker compose compatible client to deploy to Rancher"
  homepage "https://github.com/rancher/rancher-compose"
  url "https://github.com/rancher/rancher-compose/archive/v0.6.2.tar.gz"
  sha256 "c4df1cb0a669e6825035ca9a26da04b723531656ef1ec3e076c1bbd2bb80fe97"

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
