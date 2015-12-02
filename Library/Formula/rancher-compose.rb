class RancherCompose < Formula
  desc "Docker compose compatible client to deploy to Rancher"
  homepage "https://github.com/rancher/rancher-compose"
  url "https://github.com/rancher/rancher-compose/archive/v0.5.3.tar.gz"
  sha256 "381e187e104da74753cd44b2201008a1abd4423e8862b082f83e1d685d21c206"

  bottle do
    cellar :any_skip_relocation
    sha256 "9d895e3c337f4a0bc0d520a2233eb7cf493ef0719034850f5fb7e8ed3b902ffa" => :el_capitan
    sha256 "b77a3e5af1e56af9ef9c68c478d104ef2c57ff3dfc0fe204227af48721674dc5" => :yosemite
    sha256 "fa0311a16d136b91fffe520f66759756fcfa219086d10097d97ba9a3ea5d940c" => :mavericks
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
