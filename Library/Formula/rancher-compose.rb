class RancherCompose < Formula
  desc "Docker compose compatible client to deploy to Rancher"
  homepage "https://github.com/rancher/rancher-compose"
  url "https://github.com/rancher/rancher-compose/archive/v0.2.6.tar.gz"
  sha256 "eb52c47ac42b2ecf5cb33d6c78faac8f91b040b23801e42638c4d247db2e1590"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = "#{buildpath}:#{buildpath}/Godeps/_workspace"
    mkdir_p "#{buildpath}/src/github.com/rancherio"
    ln_s buildpath, "#{buildpath}/src/github.com/rancherio/rancher-compose"
    system "go", "build", "-ldflags", "-w -X github.com/rancherio/rancher-compose/version.VERSION #{version}", "-o", "#{bin}/rancher-compose"
  end

  test do
    system "#{bin}/rancher-compose", "help"
  end
end
