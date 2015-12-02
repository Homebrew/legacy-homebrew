class RancherCompose < Formula
  desc "Docker compose compatible client to deploy to Rancher"
  homepage "https://github.com/rancher/rancher-compose"
  url "https://github.com/rancher/rancher-compose/archive/v0.5.3.tar.gz"
  sha256 "381e187e104da74753cd44b2201008a1abd4423e8862b082f83e1d685d21c206"

  bottle do
    cellar :any_skip_relocation
    sha256 "623cfafba5ded7308e24f95d248006d90f333d90e0a7f2c69142f1c3c40c19ac" => :el_capitan
    sha256 "47ef175b232ef83cb47121fe7a338b71d6efc82b8b8024dde8442cc03a298123" => :yosemite
    sha256 "bfa6ae603f04439b5556c33e10919ceb2b838e69d58b5194cfb8684e5f04f02e" => :mavericks
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
