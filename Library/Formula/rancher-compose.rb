class RancherCompose < Formula
  desc "Docker Compose compatible client to deploy to Rancher"
  homepage "https://github.com/rancher/rancher-compose"
  url "https://github.com/rancher/rancher-compose/archive/v0.7.1.tar.gz"
  sha256 "2887e2c40d5b6559ff1d4ec5f11df1260dd9e0bdf8125f89c7788db311b13f20"

  bottle do
    cellar :any_skip_relocation
    sha256 "d3f309e54ee631d2a1dfb8c95578cf0b1379b72a4473b80d95aefb89fb5564f7" => :el_capitan
    sha256 "eda874f148879adcee49e9d5a968dc1dc606a36bb3b9d78649fbe97dc024602f" => :yosemite
    sha256 "ea3cba54eee02c6d66d31923b3b9f598c8677034f280bd475a5cc36b960b62ed" => :mavericks
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
